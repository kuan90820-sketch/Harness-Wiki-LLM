---
description: 針對現有 wiki 提問 — 執行 query skill（讀 index → 讀相關頁 → 綜合作答附引用 → 問使用者要不要回填成 syntheses 一頁）
---

# /query — 對 wiki 提問

執行 **query skill**（[`.claude/skills/query/SKILL.md`](../skills/query/SKILL.md)），完整走完步驟 1–5。

## 使用方式

```
/query <你的問題>
```

例如：

```
/query 第三章與第七章對「習慣養成」的論述差在哪？
/query 目前 wiki 裡關於「身分認同型習慣」的證據有哪些？
/query 給我一份「2025 年到目前為止 ingest 過的所有 source」的時序整理。
```

## 你（agent）的動作

1. 讀根目錄的 [`AGENTS.md`](../../AGENTS.md) 與 [`CLAUDE.md`](../../CLAUDE.md) 喚起 wiki 公約。
2. 載入並執行 **query skill** 的完整 SOP（步驟 1–5）。
3. **優先從 wiki 取材，不從訓練語料補**——這條紀律寫在 skill 的「邊界」段。
4. 答完之後，**主動詢問使用者**「要不要把這個分析回填成 `wiki/syntheses/` 一頁」（步驟 4）。

> 🔁 這份 command 是 Claude Code slash command 的薄殼。真正的邏輯在 `.claude/skills/query/SKILL.md`，更新 SOP 時請改那一份，這裡不用動。
