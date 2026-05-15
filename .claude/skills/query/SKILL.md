---
name: query
description: 針對現有 wiki 提問。觸發時機：使用者說「問 …」「查 …」「回答 …」或對 wiki 中已有主題提出問題時。
---

# Query 工作流

> 針對現有 wiki 提問。重點：**從 wiki 答，不從訓練語料答**。好的回答會被回填成新頁。

## 觸發

使用者問了一個關於 `{{TOPIC}}` 的問題，例如：

- 「X 與 Y 在 Z 議題上的立場差異？」
- 「目前 wiki 裡關於 W 的證據有哪些？」
- 「給我一份 V 的時序整理。」

## 你的角色

你是這個 wiki 的**檢索 + 綜合**助手。優先從 wiki 取材；當 wiki 不足時，明確告訴使用者「wiki 沒有，需要找 source」，而非用訓練資料補。

## SOP

### 步驟 1：先讀 index

- 開 [`wiki/index.md`](../../../wiki/index.md)，找與問題相關的 entity / concept / synthesis 頁。
- 列出**你打算讀哪幾頁**（給使用者一秒檢查方向是否對）。

### 步驟 2：讀相關頁

- 點進去讀。沿著 `🔗 See also` 的連結擴展。
- 同時注意 `## ⚠️ Contradictions` 與 `> [!unverified]` callout——這些會影響答案的確定性。

### 步驟 3：綜合作答

回答必須包含：

1. **直接回答**——一兩句話講結論。
2. **依據**——附 wiki 內部連結引用，例：`根據 [Lalit Maganti](../../../wiki/entities/lalit-maganti.md)，他主張……`。
3. **不確定處**——若 wiki 內證據不足、有矛盾，明白寫出來。**不要為了答得漂亮而過度自信**。
4. **wiki 缺口**——若這個問題暴露 wiki 缺什麼，列出來。

### 步驟 4：問使用者要不要回填

如果這個回答夠精彩、值得保留，問使用者：

> 這個分析要回填成 `wiki/syntheses/<建議檔名>.md` 嗎？

得到同意後：

- 在 `wiki/syntheses/` 建頁，套用 [`.claude/Docs/wiki-syntheses.md`](../../Docs/wiki-syntheses.md) 的模板。
- frontmatter 的 `trigger: query`。
- 更新 [`wiki/index.md`](../../../wiki/index.md)。
- append [`wiki/log.md`](../../../wiki/log.md)：
  ```
  ## [YYYY-MM-DD] query | <問題摘要>

  - 答案回填：`wiki/syntheses/<新檔>.md`
  - 引用頁：x.md、y.md、z.md
  - 暴露的 wiki 缺口：……
  ```
- 跑 `bash scripts/check-consistency.sh`。

### 步驟 5：把 open question 補進去

任何過程中冒出來、但沒答完的問題，加進 [`wiki/syntheses/open-questions.md`](../../../wiki/syntheses/open-questions.md)。

## 邊界

- **wiki 沒寫過的事，不要編。** 直接說「目前 wiki 沒有 X 的資料」，並建議使用者：(a) 找特定 source 來 ingest，(b) 上網搜某關鍵字，(c) 直接寫進 open questions。
- **訓練資料的事實 vs wiki 內事實**：當兩者衝突，**以 wiki 為準**——除非使用者明確要你用 wiki 之外的知識；那種情況下要明白標註「以下不是來自 wiki」。
