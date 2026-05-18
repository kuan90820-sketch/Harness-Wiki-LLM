---
description: 畫技術架構圖/流程圖/心智圖 — 邏輯本體在 .claude/skills/fireworks-tech-graph/SKILL.md
---

# /graph — 生成技術架構圖與流程圖

**邏輯本體住在** [`.claude/skills/fireworks-tech-graph/SKILL.md`](../../.claude/skills/fireworks-tech-graph/SKILL.md)。  
這份 workflow 是 Antigravity 用的入口薄殼；非 Claude Code 工具如果讀不到 `.claude/skills/`，可改讀 [`prompts/graph.md`](../../prompts/graph.md)（轉介薄殼）。請打開上述本體，遵循裡面定義的圖表生成流程。

## 使用方式

```
/graph <描述>
```

例如：
```
/graph 幫我畫一個 Agentic RAG 的架構圖
```

## 你（agent）的動作

1. 讀取 [`.claude/skills/fireworks-tech-graph/SKILL.md`](../../.claude/skills/fireworks-tech-graph/SKILL.md) 取得完整生成步驟與圖表規則（或經由 `prompts/graph.md` 薄殼轉介）。
2. 根據使用者提供的描述，**分析並決定圖表類型**（Architecture, Flowchart, Sequence 等）。
3. 遵循 SKILL.md 裡面的「Workflow (Always Follow This Order)」步驟生成 SVG，並轉換匯出圖片。
4. 將產出的檔案路徑與圖片呈現給使用者確認。

> 🔁 這份 workflow 是 Antigravity slash command 的薄殼。真正的邏輯在 `.claude/skills/fireworks-tech-graph/SKILL.md`，更新圖表規則時請改那一份，這裡不用動。
