# Ingest 工作流

> 把一份新 source 整合進 wiki。這是最高頻、最重要的操作。

## 觸發

使用者放了新檔到 `raw/`，並說：

> 請按 `prompts/ingest.md` 處理 `raw/<檔名>`。

## 你的角色

你是這個 wiki 的維護者。對單一 source 負責：**讀懂它、抽精華、整進現有結構、留下可追溯的 trail**。不要只寫一頁 summary 就交差——要連動更新所有受影響的 entity / concept 頁。

## SOP（必跑完每一步）

### 步驟 1：讀

- 先讀根 [`CLAUDE.md`](../CLAUDE.md) 與 [`wiki/AGENTS.md`](../wiki/AGENTS.md) 喚起公約。
- 讀 [`wiki/index.md`](../wiki/index.md) 知道 wiki 現有什麼。
- 讀目標 source（含圖片，如果有）。
- **如果這是 PDF / 長文**：先掃目錄與摘要，再決定深讀哪幾段。

### 步驟 2：與使用者快速對齊

- 用 3–5 條 bullet 報出 source 的 TL;DR。
- 問使用者：「這份 source 對 `{{TOPIC}}` wiki 來說，哪些段落最值得抽？有特別想強調或忽略的嗎？」
- **等使用者回應再繼續**——除非使用者明確說「按你判斷」。

### 步驟 3：寫 summary

- 在 `wiki/summaries/` 建一頁，檔名 `YYYY-MM-DD-<source-slug>.md`（YYYY-MM-DD 是 source 發布日）。
- 套用 [`wiki/summaries/AGENTS.md`](../wiki/summaries/AGENTS.md) 的模板。
- TL;DR、核心論點、關鍵資料、與 wiki 主題的關聯，缺一不可。

### 步驟 4：跨頁更新（最關鍵）

掃 source 中提到的所有專有名詞 / 概念，逐個處理：

- **是新實體？** → 在 `wiki/entities/` 建新頁，引用此 summary。
- **已存在實體頁？** → 補一段，引用此 summary，更新 frontmatter 的 `sources` 與 `updated`。
- **是新概念？** → 通常**先觀察**，只有跨多份 source 出現才升級到 `concepts/`。第一次出現時，把概念寫在 summary 內即可。
- **是已存在概念？** → 在該 concept 頁加入新 source 的視角，特別是不同論述時用「## Evolution」段。
- **發現矛盾？** → 在相關頁加 `## ⚠️ Contradictions` 段，並列引用兩邊。

### 步驟 5：更新 index 與 log

- 把所有新建頁列進 [`wiki/index.md`](../wiki/index.md) 對應分類。
- 更新 index 末尾的「統計快照」表（Entities / Concepts / Summaries / Syntheses 計數）與「最後更新」日期。
- 在 [`wiki/log.md`](../wiki/log.md) append：
  ```
  ## [YYYY-MM-DD] ingest | <source 標題>

  - source: `raw/<檔名>`
  - summary: `wiki/summaries/<新檔>.md`
  - 影響頁：`entities/x.md`（新建）、`concepts/y.md`（補段）、`entities/z.md`（補引用）
  - 新增 Open Questions：N 條
  ```

### 步驟 6：跑機械化檢查

```
bash scripts/check-consistency.sh
```

有錯就修。檢查全綠才算 ingest 完成。

### 步驟 7：回報

簡短回報使用者：
- 寫了哪些頁（含相對路徑連結，方便點開）
- 動到了哪些舊頁
- 發現了什麼矛盾 / open questions
- 建議的下一個 source（如果這份 source 提到的延伸資料值得追）

## 不要做的事

- **不要**修改 `raw/` 任何檔案。
- **不要**沒讀完 source 就寫 summary。
- **不要**把 source 中與 wiki 主題無關的內容塞進實體頁（會稀釋訊噪比）。
- **不要**為了「看起來豐富」憑空建概念頁——遵守「跨多份 source 才升級」的紀律。
- **不要**跳過 log 與 index 更新，那是給你自己未來查的安全網。
