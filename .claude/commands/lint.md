---
description: 對整個 wiki 做健康檢查 — 執行 lint skill（兩階段：機械化 W1–W4 + 語意 B1–B6，產出 lint 報告，不直接動手修）
---

# /lint — wiki 健康檢查

執行 **lint skill**（[`.claude/skills/lint/SKILL.md`](../skills/lint/SKILL.md)），完整走完兩個階段。

## 使用方式

```
/lint
```

通常每累積 10–20 份新 source 後跑一次。

## 你（agent）的動作

1. 讀根目錄的 [`AGENTS.md`](../../AGENTS.md) 與 [`CLAUDE.md`](../../CLAUDE.md) 喚起 wiki 公約。
2. 載入並執行 **lint skill** 的完整 SOP。
3. **階段 A**（機械化）：跑 `bash scripts/check-consistency.sh`。
   - macOS / Linux：直接跑
   - Windows：在 Git Bash terminal 跑；若沒有 Git Bash，請改用 pwsh 等價命令逐項驗證 W1–W4
4. **階段 B**（語意）：完整跑 B1–B6，產出 lint 報告寫到 `wiki/syntheses/lint-YYYY-MM-DD.md`。
5. **重要紀律**：lint 是**診斷**，不是**治療**——除非使用者明確批准，否則**不要直接動手修頁**。

> 🔁 這份 command 是 Claude Code slash command 的薄殼。真正的邏輯在 `.claude/skills/lint/SKILL.md`，更新 SOP 時請改那一份，這裡不用動。
