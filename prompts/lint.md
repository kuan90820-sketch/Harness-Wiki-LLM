# Lint 工作流

> 定期 wiki 健康檢查。找矛盾、孤兒、過期、缺頁、缺引用、可補的研究題目。

## 觸發

使用者每累積 10–20 份 source 後說：

> 請按 `prompts/lint.md` 對 wiki 做一次健康檢查。

或乾脆：「lint wiki」。

## 你的角色

你是 wiki 的**內審員**。目標是**指出問題、給建議**，不是自己悄悄動手——讓使用者決定哪些要修、哪些是有意保留的。

## 兩階段：機械化 + 語意

### 階段 A：機械化（先跑，最快）

```
bash scripts/check-consistency.sh
```

把腳本輸出原樣貼回，並逐項翻譯人話：
- W1 失敗 → 哪些頁在 wiki 但沒進 index，或反過來
- W2 失敗 → log.md 哪行格式錯
- W3 失敗 → 哪些連結斷
- W4 失敗 → 哪些 raw source 還沒被 ingest

W1–W4 都修完後再進階段 B。

### 階段 B：語意檢查（你的本職）

針對下列項目逐一掃描，**寫成一份 lint 報告**給使用者（**不要直接動手修**，除非使用者批准）：

#### B1. 矛盾（Contradictions）

讀全部 entity / concept / synthesis 頁，找：
- 同一實體在不同頁的說法不一致
- 標了 `## ⚠️ Contradictions` 但沒附引用，或證據已失效

報告格式：
```
- [實體 X](../wiki/entities/x.md) 與 [概念 Y](../wiki/concepts/y.md) 對 Z 說法不同
  - X 頁說：……（引用 source A）
  - Y 頁說：……（引用 source B）
  - 建議：合併到 X 頁的 Contradictions 段
```

#### B2. 孤兒頁（Orphans）

沒有任何其他頁連到的頁面（不含 index.md / log.md / open-questions.md / 各 AGENTS.md）：
```
grep -L "<filename>" wiki/**/*.md  # 對每頁跑
```

孤兒頁不一定是錯——可能只是還沒被引用。報告它，由使用者判斷要不要補引用。

#### B3. 過期主張（Stale claims）

挑出 `updated` 早於最近 N 個月的頁，與最近 ingest 的 source 對照：
- 最近的 source 有沒有顛覆 / 補充這頁的論點？
- syntheses 頁特別容易過期——新 source 進來後綜合常常需要更新。

#### B4. 缺頁（Missing pages）

掃 entity / concept 頁面內文中提到、但**沒建頁**的專有名詞（用大寫專有名詞、引號、粗體當啟發）。
- 是該升級成獨立頁的概念嗎？
- 還是這次提到只是順帶一筆？

#### B5. 缺交叉引用

每頁底部 `🔗 See also` 是否與內文提到的其他 wiki 頁一致？

#### B6. 可補的研究題目

從 [open-questions.md](../wiki/syntheses/open-questions.md) 與本次掃出的 contradictions 中，挑出：
- 上網搜某幾個關鍵字就能補洞的（建議使用者用 web search）
- 需要找特定 source（書、論文、訪談）來解的
- 純粹要使用者自己想清楚的

## 報告產出

最終給使用者一份 lint 報告，存到 `wiki/syntheses/lint-YYYY-MM-DD.md`，frontmatter `trigger: lint`。內容結構：

```markdown
# Lint Report — YYYY-MM-DD

## 機械化檢查（W1–W4）

✅ / ❌ 各項，附細節

## 矛盾（B1）

- ...

## 孤兒頁（B2）

- ...

## 過期主張（B3）

- ...

## 缺頁（B4）

- ...

## 缺交叉引用（B5）

- ...

## 建議的下一輪研究（B6）

- ...

## 統計

- 本次掃了 N 頁
- 發現 X 個矛盾、Y 個孤兒、Z 個過期主張
- 建議優先處理：……
```

完成後在 [`wiki/log.md`](../wiki/log.md) append：
```
## [YYYY-MM-DD] lint | full sweep

- 報告：`wiki/syntheses/lint-YYYY-MM-DD.md`
- 主要 finding：……
```

## 紀律

- **不要直接修頁**，除非使用者明確說「直接修」。lint 是診斷，治療是另一個操作。
- **不要把所有問題列出**而沒有排序——告訴使用者「最該先處理」的 3–5 條。
- 如果某個檢查項目對這個 wiki 的當前規模沒意義（例如 wiki 只有 5 頁，講孤兒就過早），明說「跳過 B2，wiki 還太小」。
