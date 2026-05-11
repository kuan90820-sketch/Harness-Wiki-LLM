# raw/ — 不可變原始 source

> **此目錄由人類擁有與管理。LLM 只讀，永不修改、刪除、改名。**

## 放什麼進來

任何你想餵給 wiki 的原始資料：

- 文章（`.md`、`.txt`、`.html`、Obsidian Web Clipper 的輸出）
- PDF / 論文 / 報告
- 螢幕截圖、圖片（`.png` / `.jpg`）
- 訪談 / Podcast 逐字稿
- 資料檔（`.csv` / `.json`）
- 自己的筆記、剪報

## 命名建議

`YYYY-MM-DD-<source-slug>.<ext>`：

- `2026-04-02-fowler-harness-engineering.md`
- `2026-03-15-openai-codex-symphony.pdf`
- `2025-11-08-maganti-blog-post.html`

日期是 **source 自身的發布日**（非取得日）。這樣 `ls raw/` 是時序排列。

如果不知道發布日，用取得日並在後面加 `-acquired`：`2026-04-02-some-source-acquired.md`。

## 子目錄（可選）

依量級判斷：

- 量小（< 50 份）→ 直接平鋪在 `raw/`
- 量大或多媒體混合 → 建議：
  - `raw/articles/`
  - `raw/papers/`
  - `raw/transcripts/`
  - `raw/assets/`（圖片、附件——若用 Obsidian Web Clipper 自動下載圖檔，把 attachment folder 設這裡）

## 與 wiki/summaries 的對應

每份 raw source **必須**在 `wiki/summaries/` 有一頁對應（在 ingest 時建立）。`scripts/check-consistency.sh` 的 W4 檢查會列出**沒有 summary 的 source**——那是還沒被 LLM 讀過的。

## LLM 注意事項

- **不要修改、移動、刪除這個目錄下任何東西。** 如果發現 source 命名怪、格式錯，提醒使用者修正，不要自己動。
- 讀 source 時可以解析 markdown / PDF / 圖片，但要在 wiki 頁中正確引用回原檔。
- 引用 raw source 用相對路徑：`../../raw/2026-04-02-foo.md`（從 `wiki/summaries/` 出發）。
