# AGENTS.md

這個檔案是給 OpenAI Codex / Google Antigravity / 其他相容 `AGENTS.md` 慣例的 agent 用的入口。

**所有規則寫在 [CLAUDE.md](CLAUDE.md)——請直接讀那一份。** 這個 AGENTS.md 只是指路。

如果你發現兩份檔案的指引出現分歧，**以 CLAUDE.md 為準**；同時提醒使用者修這份 AGENTS.md。

## Slash commands（Antigravity 專用）

Antigravity 的 slash command 會找 `.agent/workflows/<name>.md`，不會找 `prompts/`。為此 repo 提供三個薄殼，對應 `prompts/` 三份 SOP：

| Slash | 薄殼 | 真正邏輯 |
|-------|------|---------|
| `/ingest` | [`.agent/workflows/ingest.md`](.agent/workflows/ingest.md) | [`prompts/ingest.md`](prompts/ingest.md) |
| `/query` | [`.agent/workflows/query.md`](.agent/workflows/query.md) | [`prompts/query.md`](prompts/query.md) |
| `/lint` | [`.agent/workflows/lint.md`](.agent/workflows/lint.md) | [`prompts/lint.md`](prompts/lint.md) |

**更新 SOP 時改 `prompts/` 那邊就好**，薄殼通常不用動。Claude Code / Codex 用戶可以直接用 `prompts/` 內的觸發語（「請按 prompts/ingest.md 處理 raw/X」），效果一樣。
