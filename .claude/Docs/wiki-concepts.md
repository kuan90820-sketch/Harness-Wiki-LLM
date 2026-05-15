# wiki/concepts/

概念頁：**抽象的方法論、術語、模型、原則、現象**。跨 source 多次出現的「想法」。

## 命名

`kebab-case.md`，用概念的權威名稱：
- `harness-engineering.md`
- `progressive-disclosure.md`
- `entropy-management.md`
- `flow-state.md`

## 模板

```markdown
---
title: 概念名稱
type: concept
tags: [methodology, principle, ...]
sources:
  - ../summaries/<最早提出這個概念的 source>.md
  - ../summaries/<延伸或質疑的 source>.md
updated: YYYY-MM-DD
---

# {{title}}

> TL;DR：一兩句話講清楚這個概念是什麼。

## 定義

最權威的定義（含出處）。如果不同 source 給出不同定義，用「## Definitions」並列。

## 核心要素

- 要素一：...
- 要素二：...

## 應用 / 例子

- 在 X 場景下：...
- 在 Y 場景下：...

## 對立 / 比較

- 與 [相關概念 A](concept-a.md) 的差異：...
- 容易混淆的：...

## ⚠️ Contradictions

（不同 source 的不一致）

## 🔗 See also

- [相關概念](xxx.md)
- [實踐這個概念的實體](../entities/xxx.md)
- 來源：[source 摘要](../summaries/xxx.md)
```

## 寫作要點

- **概念頁應該綜合多個 source 的觀點**，不該只是某一篇文章的副本（那是 `summaries/` 的事）。
- 演進中的概念：用「## Evolution」段記錄不同時期 / 不同人的版本。
- 如果某個概念只出現過一次、沒被多處引用，**不要**急著建概念頁——先放在那篇 summary 裡，等它真的成為跨 source 主題再升級。
