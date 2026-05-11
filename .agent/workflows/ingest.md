---
description: 把一份新 source 整合進 wiki — 完整 SOP 在 prompts/ingest.md（讀 → 對齊 → 寫 summary → 跨頁更新 → 更新 index/log → 機械化檢查 → 回報）
---

# /ingest — 把新 source 整合進 wiki

**完整 SOP 住在** [`prompts/ingest.md`](../../prompts/ingest.md)。請打開那份，**逐步驟（1–7）跑完**。

## 使用方式

```
/ingest raw/<檔名>
```

例如：
```
/ingest raw/2026-04-原子習慣-第三章.pdf
```

## 你（agent）的動作

1. 讀根目錄的 [`AGENTS.md`](../../AGENTS.md) 與 [`CLAUDE.md`](../../CLAUDE.md) 喚起 wiki 公約。
2. 讀 [`prompts/ingest.md`](../../prompts/ingest.md) 取得本次工作流的完整 SOP。
3. 完整執行該 SOP 的步驟 1–7，**不可省略「步驟 2：與使用者快速對齊」**。
4. 如果使用者沒在 `/ingest` 後面附檔名，先問「要 ingest `raw/` 下的哪一份？」再開工。

> 🔁 這份 workflow 是 Antigravity slash command 的薄殼。真正的邏輯在 `prompts/ingest.md`，更新 SOP 時請改那一份，這裡不用動。
