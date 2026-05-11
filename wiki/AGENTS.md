# wiki/ — LLM 維護的知識庫

> 這個目錄**完全由 LLM 擁有與維護**。使用者只讀，不寫（除非要改 schema）。

## 子目錄分工

| 目錄 | 放什麼 | 命名範例 |
|------|--------|---------|
| `entities/` | 實體頁：人、組織、產品、地點、事件 | `lalit-maganti.md`、`openai.md`、`taipei-101.md` |
| `concepts/` | 概念頁：方法論、術語、模型、原則 | `harness-engineering.md`、`flow-state.md` |
| `summaries/` | **每篇 source 一頁**摘要 | `2026-04-02-fowler-harness-engineering.md` |
| `syntheses/` | 跨 source 綜合：比較、論點、清單、發現、Open Questions | `comparison-rag-vs-wiki.md`、`open-questions.md` |

選擇規則：
- 一個專有名詞、會被多次引用 → `entities/`
- 一個抽象概念、跨 source 出現 → `concepts/`
- 一份具體 source 的內容濃縮 → `summaries/`（每份 source 一頁，1:1）
- 你或使用者問出來的問題、跨 source 的綜合分析 → `syntheses/`

## 共同 frontmatter

```yaml
---
title: 頁面標題
type: entity | concept | summary | synthesis
tags: [tag1, tag2]
sources:
  - ../summaries/2026-04-02-fowler-harness-engineering.md
  - ../../raw/some-pdf.pdf
updated: 2026-05-05
---
```

`sources` 欄位很重要——`scripts/check-consistency.sh` 用它檢查 W4（每份 raw source 都有 summary）與引用的可達性。

## 共同段落結構

每頁建議包含：

1. **TL;DR** — 一兩句話
2. **內容主體** — 視 type 而定（見各子目錄 `AGENTS.md`）
3. **⚠️ Contradictions**（如有）— 並列引用衝突來源
4. **🔗 See also** — 與本頁相關的 wiki 頁清單

## 寫作紀律

- **每次新增或重大修改一頁，必做三件事**：
  1. 更新該頁 frontmatter 的 `updated`
  2. 更新 [`index.md`](index.md) 對應條目（沒有就新增）
  3. append [`log.md`](log.md) 一行：`## [YYYY-MM-DD] update | <頁面相對路徑> — <一句改了什麼>`
- 引用其他頁用相對路徑：`[XYZ](../entities/xyz.md)`。**不要**用 `[[wikilinks]]`。
- 不確定的主張：用 `> [!unverified]` callout，並在 `syntheses/open-questions.md` 補一筆。
- 不要在頁面內塞冗長的歷史紀錄；那是 `log.md` 的事。

## 下一步

- 要寫 entity → [`entities/AGENTS.md`](entities/AGENTS.md)
- 要寫 concept → [`concepts/AGENTS.md`](concepts/AGENTS.md)
- 要寫 source 摘要 → [`summaries/AGENTS.md`](summaries/AGENTS.md)
- 要寫綜合分析 → [`syntheses/AGENTS.md`](syntheses/AGENTS.md)
