# prompts/

存放**三大操作的工具中立轉介薄殼**。

> 自 Plan 1（2026-05-15）後，邏輯本體已搬至 `.claude/skills/<name>/SKILL.md`。`prompts/` 內三份檔案降級為一句話薄殼，保留給 Antigravity 等讀不到 `.claude/skills/` 的工具透過 `.agent/workflows/` 間接取得 SOP。

| 檔案 | 對應操作 | 真正邏輯本體 |
|------|---------|---------------|
| [`prompts/ingest.md`](../../prompts/ingest.md) | Ingest | [`.claude/skills/ingest/SKILL.md`](../skills/ingest/SKILL.md) |
| [`prompts/query.md`](../../prompts/query.md)   | Query  | [`.claude/skills/query/SKILL.md`](../skills/query/SKILL.md)   |
| [`prompts/lint.md`](../../prompts/lint.md)     | Lint   | [`.claude/skills/lint/SKILL.md`](../skills/lint/SKILL.md)     |

## 慣例

- **修改 SOP 時改 `.claude/skills/<name>/SKILL.md`**，薄殼通常不用動。
- 薄殼內容只應是一句話「邏輯本體已搬至 ... 請讀那份」加相對連結，不放任何實質 SOP 內容。
- 變更 skill 內容時，順手在 `wiki/log.md` 補一筆 `## [date] schema | .claude/skills/<name>/SKILL.md — <改了什麼>`。

## 擴充新工作流

當你發現某類提問值得固定下來，**在 `.claude/skills/` 新增一個 skill 目錄**（不是在 prompts/）。例如：
- `.claude/skills/compare/SKILL.md` — A vs B 比較表的標準產出
- `.claude/skills/timeline/SKILL.md` — 從多份 source 抽時序事件
- `.claude/skills/survey/SKILL.md` — 對某主題做文獻綜述

若希望該 skill 也能透過 `/<name>` slash command 或 Antigravity `/` 觸發，再分別補：
- `.claude/commands/<name>.md`（Claude Code 入口薄殼）
- `.agent/workflows/<name>.md`（Antigravity 入口薄殼）
- `prompts/<name>.md`（轉介薄殼，可選）
