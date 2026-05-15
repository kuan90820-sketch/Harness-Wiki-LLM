---
description: 把一份新 source 整合進 wiki — 執行 ingest skill（讀 → 對齊 → 寫 summary → 跨頁更新 → 更新 index/log → 機械化檢查 → 回報）
---

# /ingest — 把新 source 整合進 wiki

執行 **ingest skill**（[`.claude/skills/ingest/SKILL.md`](../skills/ingest/SKILL.md)），完整走完步驟 1–7。

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
2. 載入並執行 **ingest skill** 的完整 SOP（步驟 1–7）。
3. **不可省略「步驟 2：與使用者快速對齊」**。
4. 如果使用者沒在 `/ingest` 後面附檔名，先問「要 ingest `raw/` 下的哪一份？」再開工。

> 🔁 這份 command 是 Claude Code slash command 的薄殼。真正的邏輯在 `.claude/skills/ingest/SKILL.md`，更新 SOP 時請改那一份，這裡不用動。
