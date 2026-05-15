![License: MIT](https://img.shields.io/badge/license-MIT-blue)
![Template](https://img.shields.io/badge/template-LLM%20Wiki-purple)
![Pattern](https://img.shields.io/badge/pattern-Harness%20%2B%20Wiki-orange)
![Agent](https://img.shields.io/badge/agent-Claude%20%7C%20Codex%20%7C%20Antigravity-green)

# Harness Wiki LLM 模板

> 一個 **LLM 維護的個人知識庫模板**，融合兩套設計哲學：
>
> - **LLM Wiki**（[Andrej Karpathy LLM Wiki 架構.md](Andrej%20Karpathy%20LLM%20Wiki%20架構.md)）— 三層結構（raw / wiki / prompts）+ Ingest / Query / Lint 三大操作。
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

## 👶 給第一次接觸的人（沒有程式背景也能讀）

> 如果你已熟悉 Git 與 CI/CD，可以直接跳到 [🧭 架構速覽](#-架構速覽三層--一張地圖)。

### 五個核心資料夾一眼看懂

```
你的知識庫專案
│
├── 📥 raw/             ← 你丟進來的原始資料（只讀，永不修改）
├── 📖 wiki/            ← AI 整理好的知識頁面（成果區）
├── 🤖 .claude/skills/  ← 告訴 AI「怎麼工作」的說明書
├── 🛡️ .githooks/      ← 存檔前的「品質守門員」（在你電腦上跑）
└── ☁️ .github/        ← 上傳雲端後的「品質守門員」（在 GitHub 跑）
```

#### 📥 `raw/` — 你的原始資料倉庫

**比喻：** 就像你的抽屜，把找到的資料、文章、筆記全部丟進來。

- 把素材（文章、PDF 轉文字、書摘、訪談記錄）放進 `raw/`
- 對 AI 說：「處理 `raw/xxx.md`」或輸入 `/ingest raw/xxx.md`
- AI 會讀取它並開始整理，你**不需要自己動手寫摘要**

**效果：** 原始資料永遠保留、永不被 AI 修改——可以反覆讓 AI 用同一份資料做不同角度的分析，整理也都有「根據」，不會憑空捏造。

#### 📖 `wiki/` — AI 整理後的知識庫

**比喻：** 就像整理好的百科全書，按主題分類排好。

```
wiki/
├── summaries/   ← 每份原始資料的「濃縮摘要」（與 raw/ 一對一）
├── entities/    ← 人物、組織、產品的專屬頁面
├── concepts/    ← 抽象術語、理論、方法的解釋頁
├── syntheses/   ← AI 跨多份資料綜合分析的頁面
├── index.md     ← 所有頁面的總目錄（像書的目錄）
└── log.md       ← 每次修改的紀錄（像工作日誌）
```

- **讀**：直接打開 `wiki/index.md` 瀏覽所有已整理的頁面
- **問**：對 AI 說「問 XXX」，AI 會先讀 index，再讀相關頁，然後綜合回答你，並附上引用來源
- **檢查**：你隨時可以翻開任何 wiki 頁確認 AI 說的有沒有根據

**效果：** 知識有系統地連結——人名、術語、主題互相交叉引用，不再是孤立的筆記。每次問問題，AI 都從你自己整理過的資料裡找答案，不是胡說。

#### 🤖 `.claude/skills/` — AI 的工作說明書（邏輯本體）

**比喻：** 就像給新員工的「標準作業程序手冊」，告訴 AI 遇到不同任務時每一步要怎麼做。

```
.claude/skills/
├── ingest/SKILL.md  ← 「新資料進來時」的完整步驟（共 7 步）
├── query/SKILL.md   ← 「回答問題時」的完整步驟（共 5 步）
└── lint/SKILL.md    ← 「健康檢查時」的完整步驟（A/B 兩階段）

prompts/             ← 工具中立的「薄殼」，內容只是指向上面的 skill
```

- 你通常**不需要直接讀這裡**——AI 會自動讀
- 想客製化 AI 行為（例：希望摘要一定列出「關鍵金句」），請修改 `.claude/skills/<name>/SKILL.md`（邏輯本體），不是 `prompts/`（薄殼）
- 換不同 AI 工具（Claude Code / Cursor / Antigravity）時，本體在 `.claude/skills/`，`prompts/` 薄殼讓其他工具也能找到本體

**效果：** 保證每次 AI 處理資料的方式一致，不會因為你的問法不同而產生結構差異很大的結果。客製化只需寫一次。

#### 🛡️ `.githooks/` — 本機守門員

**比喻：** 就像寄信前會自動檢查有沒有忘記貼郵票的小助手——在你的電腦上工作。

啟用一次（只需做一次）：

```bash
git config core.hooksPath .githooks
```

之後每次 `git commit` 時自動跑，不需手動觸發。

**效果：** 如果 wiki 有檔案不一致（例如 index.md 沒更新、連結斷掉），它會**阻止你存檔**並告訴你哪裡出問題，確保版本歷史裡每一筆 commit 都健康。

> 如果你完全不用 Git，可以暫時忽略這個資料夾。

#### ☁️ `.github/` — 雲端守門員

**比喻：** 就像郵局那邊也會再檢查一次地址有沒有填對——這道關卡在 GitHub 伺服器上。

- 你幾乎**不需要手動操作**——repo 放在 GitHub 上就自動生效
- 每次 `git push` 後 GitHub 會自動跑一次品質檢查
- 在 GitHub 的 **Actions** 頁籤可看結果（綠色 ✓ = 通過，紅色 ✗ = 有問題）

| 情境 | `.githooks/`（本機）| `.github/`（雲端）|
|------|---------------------|-------------------|
| 你跳過本機守門員（`--no-verify`）| 沒把關 | **雲端仍會攔截** |
| 協作者沒啟用 `.githooks/` | 沒把關 | **雲端仍會攔截** |
| PR 合併前最後一道關 | 不適用 | **是** |

### 整體流程一句話

```
你把資料放進 raw/
    ↓
AI 按照 .claude/skills/ 的說明書整理成 wiki/
    ↓
每次本機存檔時，.githooks/ 把關
    ↓
每次推上 GitHub 時，.github/ 再把關一次
```

**你只需要做三件事：** 丟資料進 `raw/`、對 AI 說話、偶爾翻 `wiki/` 確認結果。

---

## 🧠 三層職責分工（最重要的心智模型）

| 層級 | 誰擁有 | 動作 | 目錄 |
|------|--------|------|------|
| **原始層** | 使用者 | 只進不出，LLM 唯讀 | `raw/` |
| **整理層** | LLM | 讀 raw → 寫摘要 / 連結 / 綜合 | `wiki/` |
| **規則層** | 共同維護 | 規則、SOP、工具配置 | `CLAUDE.md`、`.claude/skills/`、`.claude/Docs/`、根 `AGENTS.md`、`prompts/`、`.claude/`、`.agent/` |

**口訣**：raw 是燃料、wiki 是產出、`.claude/skills/` 是說明書（`prompts/` 是工具中立的薄殼轉介）。

---

## 🧭 架構速覽（三層 + 一張地圖）

```
Harness-Wiki-LLM/
├── README.md                        ← 你在這裡（給人看）
├── CLAUDE.md                        ← 給 Claude Code 的根入口（≤100 行的「地圖」）
├── AGENTS.md                        ← 同上,給 Codex / 其他 agent
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
│   └── check-consistency.sh   # 機械化守門（W1–W4）：孤兒頁、缺索引、斷連結、缺 summary
│
├── .claude/                    # Claude Code 整合
│   ├── settings.json           #   權限白名單
│   ├── commands/               #   /ingest、/query、/lint slash command 薄殼
│   ├── skills/                 #   邏輯本體（三大操作 SOP）
│   │   ├── ingest/SKILL.md     #     7 步驟：把新 source 整合進 wiki
│   │   ├── query/SKILL.md      #     5 步驟：針對 wiki 提問並回填 syntheses
│   │   ├── lint/SKILL.md       #     兩階段：W1–W4 機械化 + B1–B6 語意健康檢查
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
├── .githooks/pre-commit        # 本地反饋：commit 前跑 W1–W4
└── .github/workflows/consistency.yml  # CI 兜底：push / PR 觸發同一腳本
```

所有子目錄寫作規定統一放在 [`.claude/Docs/`](.claude/Docs/) 下，告訴智能體「這裡放什麼、要遵守什麼規則」——這正是 Harness Engineering「地圖而非手冊」+「漸進式披露」的體現。根目錄保留 `AGENTS.md` 給 Codex / Antigravity 入口用。

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

### 實際走一次：典型工作流

**場景 A：使用者放了一份新 PDF 進 `raw/`**

```
使用者:  把 raw/2026-04-原子習慣-第三章.pdf ingest 進來
   ↓
[Claude Code]   讀 .claude/commands/ingest.md → 載入 .claude/skills/ingest/SKILL.md
[Antigravity]   讀 .agent/workflows/ingest.md → prompts/ingest.md（薄殼）→ 指向 SKILL.md
                ↓
                步驟 1: 讀 CLAUDE.md + wiki-conventions.md + wiki/index.md + source
                步驟 2: 與使用者對齊 TL;DR
                步驟 3: 寫 wiki/summaries/2026-04-原子習慣-第三章.md
                步驟 4: 跨頁更新 wiki/entities/、wiki/concepts/
                步驟 5: 更新 wiki/index.md + append wiki/log.md
                步驟 6: 跑 scripts/check-consistency.sh
                步驟 7: 回報使用者
```

**場景 B：使用者問一個問題**

```
使用者:  第三章與第七章對「習慣養成」的論述差在哪？
   ↓
                載入 .claude/skills/query/SKILL.md
                ↓
                讀 wiki/index.md → 找相關頁
                讀 wiki/entities/、concepts/、summaries/、syntheses/
                綜合作答（附引用）
                問使用者：要回填成 wiki/syntheses/ 一頁嗎？
                若同意 → 建頁 + 更新 index + log
```

**場景 C：定期健康檢查**

```
使用者:  lint wiki
   ↓
                載入 .claude/skills/lint/SKILL.md
                ↓
                階段 A：跑 scripts/check-consistency.sh（W1–W4）
                階段 B：語意檢查 B1 矛盾 / B2 孤兒 / B3 過期 / B4 缺頁 / B5 缺引用 / B6 研究題目
                產出 wiki/syntheses/lint-YYYY-MM-DD.md
                **不直接動手修**——讓使用者決定
```

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

## 📐 設計核心思想

1. **三層分離**：raw / wiki / 規則，職責不混。
2. **薄殼指向本體**：`.claude/commands/`、`.agent/workflows/`、`prompts/` 都是薄殼，邏輯只寫一份在 `.claude/skills/`，多 agent 工具共存無痛。
3. **漸進式披露**：根 `CLAUDE.md` 精簡（< 100 行），細節下放到 `.claude/Docs/` 下各規定檔，模型按需讀。
4. **機械 + 語意雙檢**：能用腳本檢的事不靠人腦（W1–W4），需要判斷的事不靠腳本（B1–B6）。
5. **雙重合併門**：本地 pre-commit + 遠端 CI 跑同一支腳本，避免漏網。
6. **診斷 ≠ 治療**：lint 只報告、不亂改;query 寫綜合前先問使用者要不要回填。**人類掌舵,AI 執行。**

### 設計取捨

- **不用 embedding RAG**：在中等規模（~100 sources / 數百頁）下，`index.md` + 檔名 + `grep` 已經夠用。需要時再加 [qmd](https://github.com/tobi/qmd) 或自己 vibe-code 一個搜尋腳本。
- **不寫巨型 instructions**：根 `CLAUDE.md` / `AGENTS.md` 壓在 ~100 行內，子目錄寫作規定拆到 `.claude/Docs/` 下逐檔分述。Harness 的「地圖而非手冊」原則。
- **不靠人類維護**：交叉引用、log、index 全部由 LLM 寫；機械化檢查兜底，避免 LLM 漂移。
- **Wiki 就是一個 git repo**：版本歷史、分支、協作免費送。搭 Obsidian 開來瀏覽（graph view、Marp、Dataview）。

---

## 🙏 致謝

- LLM Wiki 模式 — 詳見 [Andrej Karpathy LLM Wiki 架構.md](Andrej%20Karpathy%20LLM%20Wiki%20架構.md)
- Harness Engineering 學習檔案 — [deusyu/harness-engineering](https://github.com/deusyu/harness-engineering)
- 思想源頭：Vannevar Bush 的 Memex（1945）、Mitchell Hashimoto 的 *Engineer the Harness*、OpenAI Codex 團隊的 Harness Engineering 范式

## 📄 License

MIT
