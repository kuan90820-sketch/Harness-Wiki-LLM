# wiki/entities/

實體頁：**有名字、會被多次引用**的東西。人、組織、產品、地點、事件、書籍、論文。

## 命名

`kebab-case.md`，盡量用實體的常用名稱：
- 人：`lalit-maganti.md`、`martin-fowler.md`
- 組織：`openai.md`、`anthropic.md`
- 產品：`claude-code.md`、`obsidian.md`
- 事件：`2026-q1-merge-freeze.md`

## 模板

```markdown
---
title: 實體名稱
type: entity
tags: [person, company, ...]
sources:
  - ../summaries/<相關 source 摘要>.md
updated: YYYY-MM-DD
---

# {{title}}

> 一句話定位：是什麼、做什麼、為何重要。

## 基本資料

- 類型：人 / 組織 / 產品 / ...
- 別名：...
- 相關時間：...

## 關鍵主張 / 行動 / 特徵

（從 source 抽出來的、與本 wiki 主題相關的點）

- ...

## ⚠️ Contradictions

（如有，並列衝突陳述與引用）

## 🔗 See also

- [相關概念](../concepts/xxx.md)
- [相關實體](xxx.md)
- 來源：[source 摘要](../summaries/xxx.md)
```

## 寫作要點

- **只放與本 wiki 主題相關的事實**，不要寫成維基百科。例如：在「光通訊產業」wiki 裡的 `corning.md`，只寫光纖相關業務，不寫他們的廚具。
- 至少要有一個 `sources` 引用——沒 source 出現過的實體，不應該存在。
- 第一次出現某實體時建立此頁；之後其他頁引用時用相對連結 `[Corning](../entities/corning.md)`。
