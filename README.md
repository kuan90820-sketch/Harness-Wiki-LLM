![License: MIT](https://img.shields.io/badge/license-MIT-blue)
![Template](https://img.shields.io/badge/template-LLM%20Wiki-purple)
![Pattern](https://img.shields.io/badge/pattern-Harness%20%2B%20Wiki-orange)
![Agent](https://img.shields.io/badge/agent-Claude%20%7C%20Codex%20%7C%20Antigravity-green)

# Harness Wiki LLM 模板

> 一個 **LLM 維護的個人知識庫模板**，融合兩套設計哲學：
>
> - **LLM Wiki**（[架構.md](架構.md)）— 三層結構（raw / wiki / prompts）+ Ingest / Query / Lint 三大操作，靈感來自 [Andrej Karpathy LLM Wiki 架構](Andrej%20Karpathy%20LLM%20Wiki%20架構.md)。
> - **Harness Engineering**（[deusyu/harness-engineering](https://github.com/deusyu/harness-engineering)）— Repo 即真實來源、地圖而非手冊、機械化檢查、漸進式披露。
>
> **人類掌舵（選 source、提問題、定方向），LLM 執行（讀、整理、跨引、維護）。**

---

## ⚡ 一句話理解

```
傳統 RAG：文件丟進去 → 每次提問現場檢索 → 答完即忘
Harness Wiki：文件丟進去 → LLM 寫進 wiki → wiki 累積 → 提問從 wiki 答
```

核心差異：**wiki 是持久化、會複利成長的工件**。交叉引用已寫好、矛盾已標記、綜合已成形。每加一份 source、每問一個問題，wiki 都會更厚。

---

## 🧭 架構速覽（三層 + 一張地圖）

```
Harness-Wiki-LLM/
├── README.md                        ← 你在這裡（給人看）
├── CLAUDE.md                        ← 給 Claude Code 的根入口（≤100 行的「地圖」）
├── AGENTS.md                        ← 同上，給 Codex / 其他 agent
├── 架構.md                          ← 本模板設計理念（為什麼長這樣）
├── Andrej Karpathy LLM Wiki 架構.md ← 思想源頭（哲學參考）
│
├── raw/                        # Layer 1 — 不可變原始 source（人類擁有，LLM 唯讀）
│   └── （規定見 .claude/Docs/raw-conventions.md）
│
├── wiki/                       # Layer 2 — LLM 維護的知識庫（LLM 擁有）
│   ├── index.md                #   內容目錄（每次 ingest 更新）
│   ├── log.md                  #   時序 append-only 紀錄
│   ├── entities/               #   實體頁（人 / 組織 / 產品 / 地方）
│   ├── concepts/               #   概念頁（方法論、原則、術語）
│   ├── summaries/              #   單篇 source 摘要（與 raw/ 一一對應）
│   └── syntheses/              #   跨 source 綜合（比較表、論點、open-questions）
│   #  各頁類型寫作規定見 .claude/Docs/wiki-*.md
│
├── prompts/                    # Layer 3 轉介薄殼 — 給非 Claude Code 工具的入口
│   ├── ingest.md               #   薄殼，指向 .claude/skills/ingest/SKILL.md
│   ├── query.md                #   薄殼，指向 .claude/skills/query/SKILL.md
│   └── lint.md                 #   薄殼，指向 .claude/skills/lint/SKILL.md
│
├── scripts/
│   └── check-consistency.sh   # 機械化守門（W1–W5）：孤兒頁、缺索引、斷連結、缺 summary
│
├── .claude/                    # Claude Code 整合
│   ├── settings.json           #   權限白名單
│   ├── commands/               #   /ingest、/query、/lint slash command 薄殼
│   ├── skills/                 #   邏輯本體（三大操作 SOP）
│   │   ├── ingest/SKILL.md     #     7 步驟：把新 source 整合進 wiki
│   │   ├── query/SKILL.md      #     5 步驟：針對 wiki 提問並回填 syntheses
│   │   ├── lint/SKILL.md       #     兩階段：W1–W5 機械化 + B1–B6 語意健康檢查
│   │   └── karpathy-guidelines/SKILL.md  # 自動載入的精簡編碼守則
│   └── Docs/                   #   子目錄寫作規定（原各子目錄 AGENTS.md）
│       ├── raw-conventions.md          # raw/ 規則（只讀、命名）
│       ├── prompts-conventions.md      # prompts/ 慣例（轉介薄殼）
│       ├── wiki-conventions.md         # wiki 共通公約（frontmatter / 連結）
│       ├── wiki-entities.md            # entity 頁專屬規則 + 模板
│       ├── wiki-concepts.md            # concept 頁專屬規則 + 模板
│       ├── wiki-summaries.md           # summary 頁專屬規則 + 模板
│       └── wiki-syntheses.md           # synthesis 頁專屬規則 + 模板
│
├── .agent/                     # 其他 agent 框架相容層（Antigravity 等）
│   └── workflows/              #   ingest / query / lint 入口薄殼
│
├── .githooks/pre-commit        # 本地反饋：commit 前跑 W1–W5
└── .github/workflows/consistency.yml  # CI 兜底：push / PR 觸發同一腳本
```

所有子目錄寫作規定統一放在 [`.claude/Docs/`](.claude/Docs/) 下（`raw-conventions.md`、`wiki-conventions.md`、`wiki-entities.md` 等），告訴智能體「這裡放什麼、要遵守什麼規則」——這正是 Harness Engineering「地圖而非手冊」+「漸進式披露」的體現。根目錄保留 `AGENTS.md` 給 Codex / Antigravity 入口用。

---

## 🚀 快速開始

### 1. Clone 並客製化主題

```bash
git clone <this-repo> my-knowledge-base
cd my-knowledge-base
git config core.hooksPath .githooks   # 啟用本地 pre-commit 檢查
```

把 `CLAUDE.md` 開頭的 `{{TOPIC}}`、`{{DOMAIN}}` 等占位符換成你的主題（例如「光通訊產業研究」、「《魔戒》閱讀筆記」、「個人健康觀察」）。

### 2. 丟第一份 source 進去

把第一份原始資料（PDF、markdown、剪報）丟到 `raw/`，然後對你的 LLM agent 說：

> `/ingest raw/<檔名>`（或自然語：「請處理 `raw/<檔名>`」）

LLM 會：閱讀 → 與你討論重點 → 寫一頁 `wiki/summaries/` → 更新或新建相關 `entities/` 與 `concepts/` → 更新 `wiki/index.md` → 在 `wiki/log.md` 補一筆。

### 3. 提問

```
/query 「X 與 Y 在 Z 議題上的立場差異？」
```

好的回答應該被回填成 `wiki/syntheses/` 裡的一頁——這樣探索本身也會累積，而非散在聊天紀錄。

### 4. 定期體檢

每累積 10–20 筆 source 後：

```
/lint
```

---

## 🔑 三大操作

| 操作 | 觸發 | LLM 動作 | 影響檔案 |
|------|------|---------|---------|
| **Ingest** | 你丟新 source 並指示處理 | 讀 → 摘要 → 跨頁更新 → 寫 log | 一次通常觸碰 5–15 個 wiki 頁 |
| **Query** | 你提問 | 讀 index → 讀相關頁 → 綜合作答 → 詢問是否回填 | 視情況新增 `syntheses/` 一頁 |
| **Lint** | 你定期觸發 | 找矛盾、孤兒、過期主張、缺頁、可補的網搜題目 | 寫一份 lint 報告，提建議讓你決策 |

詳細工作流見 `.claude/skills/<name>/SKILL.md`（邏輯本體）；`prompts/<name>.md` 是給非 Claude Code 工具的轉介薄殼。

---

## 🛡 機械化守門（Harness 風格）

`scripts/check-consistency.sh` 守護幾類「漂移」：

- **W1** — `wiki/index.md` 列出的頁面 ≡ `wiki/**/*.md` 實際存在的頁面（無孤兒、無幽靈索引）
- **W2** — `wiki/log.md` 的條目格式為 `## [YYYY-MM-DD] <op> | <subject>`（可被 `grep "^## \["` 解析）
- **W3** — `wiki/` 內所有相對連結都指向實際存在的檔案（無 broken link）
- **W4** — `raw/` 中每份 source 至少有一筆 `wiki/summaries/` 對應頁（沒被讀過的 source 會被標出）

```bash
bash scripts/check-consistency.sh   # 手動跑
git config core.hooksPath .githooks # 啟用 pre-commit
```

CI 兜底：`.github/workflows/consistency.yml` 在每次 push / PR 觸及 `wiki/**`、`raw/**`、`README.md`、`CLAUDE.md` 時會跑同一個腳本。本地 hook 是開發期反饋，CI 才是合併門。

---

## 🧩 適用場景

| 場景 | 範例 |
|------|------|
| **個人** | 健康紀錄、自我成長、日記與書評整合 |
| **研究** | 數週至數月的主題深挖（產業、學術、技術）|
| **讀書** | 一本書一個 wiki，章節摘要 + 角色 + 主題 + 線索網 |
| **團隊** | 內部知識庫，吃 Slack / 會議逐字稿 / 客戶通話 |
| **競爭分析、盡調、旅遊規劃、興趣深挖** | 任何「越累積越值錢」的主題 |

---

## 📐 設計取捨

- **不用 embedding RAG**：在中等規模（~100 sources / 數百頁）下，`index.md` + 檔名 + `grep` 已經夠用。需要時再加 [qmd](https://github.com/tobi/qmd) 或自己 vibe-code 一個搜尋腳本。
- **不寫巨型 instructions**：根 `CLAUDE.md` / `AGENTS.md` 壓在 ~100 行內，子目錄寫作規定拆到 `.claude/Docs/` 下逐檔分述，靠連結指向更深層。Harness 的「地圖而非手冊」原則。
- **不靠人類維護**：交叉引用、log、index 全部由 LLM 寫；機械化檢查兜底，避免 LLM 漂移。
- **Wiki 就是一個 git repo**：版本歷史、分支、協作免費送。搭 Obsidian 開來瀏覽（graph view、Marp、Dataview）。

---

## 🙏 致謝

- LLM Wiki 模式 — 詳見 [架構.md](架構.md)
- Harness Engineering 學習檔案 — [deusyu/harness-engineering](https://github.com/deusyu/harness-engineering)
- 思想源頭：Vannevar Bush 的 Memex（1945）、Mitchell Hashimoto 的 *Engineer the Harness*、OpenAI Codex 團隊的 Harness Engineering 范式

## 📄 License

MIT
