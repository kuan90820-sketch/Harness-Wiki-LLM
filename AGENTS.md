# AGENTS.md

這個檔案是給 OpenAI Codex / Google Antigravity / 其他相容 `AGENTS.md` 慣例的 agent 用的入口。

**所有規則寫在 [CLAUDE.md](CLAUDE.md)——請直接讀那一份。** 這個 AGENTS.md 只是指路。

如果你發現兩份檔案的指引出現分歧，**以 CLAUDE.md 為準**；同時提醒使用者修這份 AGENTS.md。

## Slash commands（Antigravity 專用）

Antigravity 的 slash command 會找 `.agent/workflows/<name>.md`，不會找 `prompts/` 或 `.claude/skills/`。為此 repo 提供三層轉介：

| Slash | 入口薄殼 | 轉介薄殼 | 真正邏輯（本體） |
|-------|---------|---------|---------|
| `/ingest` | [`.agent/workflows/ingest.md`](.agent/workflows/ingest.md) | [`prompts/ingest.md`](prompts/ingest.md) | [`.claude/skills/ingest/SKILL.md`](.claude/skills/ingest/SKILL.md) |
| `/query`  | [`.agent/workflows/query.md`](.agent/workflows/query.md)   | [`prompts/query.md`](prompts/query.md)   | [`.claude/skills/query/SKILL.md`](.claude/skills/query/SKILL.md)   |
| `/lint`   | [`.agent/workflows/lint.md`](.agent/workflows/lint.md)     | [`prompts/lint.md`](prompts/lint.md)     | [`.claude/skills/lint/SKILL.md`](.claude/skills/lint/SKILL.md)     |
| `/graph`  | [`.agent/workflows/graph.md`](.agent/workflows/graph.md)   | [`prompts/graph.md`](prompts/graph.md)   | [`.claude/skills/fireworks-tech-graph/SKILL.md`](.claude/skills/fireworks-tech-graph/SKILL.md) |

**更新 SOP 時改 `.claude/skills/<name>/SKILL.md`（邏輯本體）**，薄殼通常不用動。Claude Code 用戶直接由 `/ingest` 觸發 skill；Antigravity 用戶經由 `.agent/workflows/` → `prompts/` 兩層薄殼指回 skill。
