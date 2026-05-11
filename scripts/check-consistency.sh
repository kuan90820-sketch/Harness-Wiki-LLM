#!/usr/bin/env bash
# scripts/check-consistency.sh — Harness-Wiki-LLM 機械化守門
#
# 檢查項：
#   W1  wiki/index.md 列的頁 ≡ wiki/**/*.md 實檔（不含 AGENTS.md / index.md / log.md）
#   W2  wiki/log.md 條目格式 `## [YYYY-MM-DD] <op> | <subject>`
#   W3  wiki/ 內所有相對連結都指到存在的檔案
#   W4  raw/ 中每份 source 都被某 wiki/summaries/*.md 提到
#   W5  CLAUDE.md 與 AGENTS.md 都存在（且 AGENTS.md 指向 CLAUDE.md）
#
# 需求：bash 4+, GNU coreutils (find / grep / sed)
# 用法：bash scripts/check-consistency.sh

set -uo pipefail

# 切到 repo root
cd "$(dirname "$0")/.."

ERRORS=0
WARN=0

red()   { printf '\033[31m%s\033[0m\n' "$1"; }
green() { printf '\033[32m%s\033[0m\n' "$1"; }
yellow(){ printf '\033[33m%s\033[0m\n' "$1"; }

fail() { red   "❌ $1"; ERRORS=$((ERRORS + 1)); }
pass() { green "✅ $1"; }
warn() { yellow "⚠️  $1"; WARN=$((WARN + 1)); }

echo "=== Harness-Wiki-LLM consistency check ==="
echo

# 把一份 .md 內的「教學雜訊」剝掉：
#   - fenced code blocks (``` ... ```)
#   - HTML 註解 (<!-- ... -->，可跨行)
#   - inline code (`...`)
# 這樣 W1 / W3 才不會把模板示例裡的假連結誤判為真連結。
strip_noise() {
    awk '
        /^```/ { in_fence = !in_fence; next }
        !in_fence { print }
    ' "$1" | sed -z 's/<!--[^>]*-->//g' | sed 's/`[^`]*`//g'
}

# ---------- W1 ----------
echo "--- W1: wiki/index.md ≡ wiki content files ---"

# wiki 實檔（不含元檔案）
mapfile -t WIKI_FILES < <(
    find wiki -type f -name "*.md" \
        ! -name "AGENTS.md" ! -name "index.md" ! -name "log.md" 2>/dev/null \
        | sed 's|^wiki/||' | sort
)

# index.md 中提到的相對 .md 路徑（剝掉 code block / HTML comment 後）
mapfile -t INDEX_REFS < <(
    strip_noise wiki/index.md \
        | grep -oE '\]\(([^)]+\.md)\)' \
        | sed -E 's/^\]\(//;s/\)$//' \
        | sort -u
)

# wiki 實檔但 index 沒列
MISSING_IN_INDEX=()
for f in "${WIKI_FILES[@]:-}"; do
    found=0
    for ref in "${INDEX_REFS[@]:-}"; do
        if [[ "$ref" == "$f" ]]; then found=1; break; fi
    done
    if [[ $found -eq 0 ]]; then MISSING_IN_INDEX+=("$f"); fi
done

# index 列了但 wiki 沒實檔
GHOST_IN_INDEX=()
for ref in "${INDEX_REFS[@]:-}"; do
    if [[ ! -f "wiki/$ref" ]]; then GHOST_IN_INDEX+=("$ref"); fi
done

if [[ ${#MISSING_IN_INDEX[@]} -eq 0 && ${#GHOST_IN_INDEX[@]} -eq 0 ]]; then
    pass "W1 — index 與實檔一致（${#WIKI_FILES[@]} 頁）"
else
    fail "W1 — index 與實檔不一致"
    if [[ ${#MISSING_IN_INDEX[@]} -gt 0 ]]; then
        echo "  實檔但 index 沒列："
        printf '    - wiki/%s\n' "${MISSING_IN_INDEX[@]}"
    fi
    if [[ ${#GHOST_IN_INDEX[@]} -gt 0 ]]; then
        echo "  index 列了但實檔不存在："
        printf '    - wiki/%s\n' "${GHOST_IN_INDEX[@]}"
    fi
fi
echo

# ---------- W2 ----------
echo "--- W2: wiki/log.md 條目格式 ---"

# 找所有 ## 開頭、但不符合 `## [YYYY-MM-DD] op | subject` 的行
BAD_LOG=$(grep -nE '^## ' wiki/log.md 2>/dev/null \
    | grep -vE '^[0-9]+:## \[[0-9]{4}-[0-9]{2}-[0-9]{2}\] (ingest|query|lint|update|schema) \| .+' \
    || true)

if [[ -z "$BAD_LOG" ]]; then
    pass "W2 — log.md 格式正確"
else
    fail "W2 — log.md 有格式錯的條目（應為 \`## [YYYY-MM-DD] <op> | <subject>\`，op ∈ {ingest, query, lint, update, schema}）："
    echo "$BAD_LOG" | sed 's/^/    /'
fi
echo

# ---------- W3 ----------
echo "--- W3: wiki/ 內相對連結可達 ---"

BROKEN_LINKS=()
while IFS= read -r mdfile; do
    dir=$(dirname "$mdfile")
    # 抽出 [...](xxx) 中的 xxx（剝掉 code block / HTML comment 後），過濾 http(s)、絕對路徑、純錨點
    while IFS= read -r link; do
        [[ -z "$link" ]] && continue
        [[ "$link" =~ ^https?:// ]] && continue
        [[ "$link" =~ ^/ ]] && continue
        [[ "$link" =~ ^# ]] && continue
        [[ "$link" =~ ^mailto: ]] && continue
        # 去掉錨點
        target="${link%%#*}"
        [[ -z "$target" ]] && continue
        # 解析相對路徑
        full_path="$dir/$target"
        if [[ ! -f "$full_path" && ! -d "$full_path" ]]; then
            BROKEN_LINKS+=("$mdfile -> $link")
        fi
    done < <(strip_noise "$mdfile" | grep -oE '\]\(([^)]+)\)' | sed -E 's/^\]\(//;s/\)$//')
done < <(find wiki -type f -name "*.md")

if [[ ${#BROKEN_LINKS[@]} -eq 0 ]]; then
    pass "W3 — 所有相對連結可達"
else
    fail "W3 — 有 ${#BROKEN_LINKS[@]} 條斷掉的相對連結："
    printf '    %s\n' "${BROKEN_LINKS[@]}"
fi
echo

# ---------- W4 ----------
echo "--- W4: raw/ 每份 source 都有 wiki/summaries 提到 ---"

mapfile -t RAW_FILES < <(
    find raw -type f \
        ! -name "AGENTS.md" ! -name ".gitkeep" 2>/dev/null \
        | sed 's|^raw/||' | sort
)

UNREAD_SOURCES=()
if [[ ${#RAW_FILES[@]} -eq 0 ]]; then
    warn "W4 — raw/ 還沒有任何 source（新模板狀態，跳過）"
else
    # 把所有 summaries 內容串起來，搜尋每份 raw 檔名是否被提到
    SUMMARIES_BLOB=""
    if compgen -G "wiki/summaries/*.md" > /dev/null; then
        SUMMARIES_BLOB=$(cat wiki/summaries/*.md 2>/dev/null || true)
        # 去掉 AGENTS.md
        SUMMARIES_BLOB=$(find wiki/summaries -type f -name "*.md" ! -name "AGENTS.md" -exec cat {} + 2>/dev/null || echo "")
    fi
    for src in "${RAW_FILES[@]}"; do
        if ! grep -qF "$src" <<< "$SUMMARIES_BLOB"; then
            UNREAD_SOURCES+=("$src")
        fi
    done
    if [[ ${#UNREAD_SOURCES[@]} -eq 0 ]]; then
        pass "W4 — 所有 ${#RAW_FILES[@]} 份 raw source 都有對應 summary"
    else
        fail "W4 — 有 ${#UNREAD_SOURCES[@]} 份 raw source 還沒被 ingest（無對應 summary）："
        printf '    - raw/%s\n' "${UNREAD_SOURCES[@]}"
    fi
fi
echo

# ---------- W5 ----------
echo "--- W5: 根入口檔存在 ---"

if [[ -f CLAUDE.md ]]; then
    pass "W5a — CLAUDE.md 存在"
else
    fail "W5a — 缺 CLAUDE.md"
fi

if [[ -f AGENTS.md ]]; then
    if grep -q "CLAUDE.md" AGENTS.md; then
        pass "W5b — AGENTS.md 存在且指向 CLAUDE.md"
    else
        warn "W5b — AGENTS.md 存在但沒提到 CLAUDE.md（建議讓兩者保持指引一致）"
    fi
else
    fail "W5b — 缺 AGENTS.md"
fi
echo

# ---------- 總結 ----------
echo "=== 結果 ==="
if [[ $ERRORS -eq 0 ]]; then
    green "✅ 全部通過（warnings: $WARN）"
    exit 0
else
    red "❌ 失敗 $ERRORS 項（warnings: $WARN）"
    exit 1
fi
