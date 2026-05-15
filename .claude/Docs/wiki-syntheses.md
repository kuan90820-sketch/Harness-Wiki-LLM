# wiki/syntheses/

跨 source 的綜合產物：**沒有任何一份 source 直接說過、但拼起來能說的事**。

## 何時建一頁 syntheses

- 使用者問了一個跨 source 的問題，回答夠精彩，**回填**成一頁
- LLM 在 ingest / lint 時發現某個跨 source 的 pattern、矛盾、空白
- 比較表（A vs B vs C）
- 時序追蹤（某概念在不同人手上如何演化）
- Open Questions 清單（永久存在的一頁）

## 命名

`kebab-case.md`：
- `comparison-rag-vs-wiki.md`
- `evolution-of-harness-concept.md`
- `open-questions.md`（這個是固定檔名，模板已預建）
- `2026-04-q1-readings-roundup.md`（如果想做時序回顧）

## 模板

```markdown
---
title: 綜合分析標題
type: synthesis
tags: [...]
sources:
  - ../summaries/aaa.md
  - ../summaries/bbb.md
  - ../entities/ccc.md
updated: YYYY-MM-DD
trigger: ingest | query | lint
---

# {{title}}

## 提問 / 動機

為什麼會有這頁？（使用者問的問題、lint 發現的 gap、ingest 觸發的洞察）

## 主張

這頁要說的核心 finding。

## 證據與推理

引用各 source，呈現推理鏈。讀者要能照著回查每一步。

## 反例 / 邊界

哪裡這個主張不成立？

## 🔗 See also

- 相關 syntheses
- 涉及的 entities / concepts
```

## 寫作要點

- **綜合 ≠ 編造**。每個主張都要能回溯到至少一份 summary 或 entity / concept 頁。
- **保留異議**。如果有 source 與你的綜合不一致，明文寫出來——這是 wiki 比文章更值錢的原因。
- syntheses 頁**會老化**。lint 時要檢查：自上次 update 以來，新 ingest 的 source 有沒有顛覆這份綜合？要嘛更新，要嘛在頁首加 `> [!stale]` 標記。
