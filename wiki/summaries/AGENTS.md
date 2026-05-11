# wiki/summaries/

每份 `raw/` source **一頁** 摘要。1:1 對應，不多不少。

## 命名

`YYYY-MM-DD-<source-slug>.md`，日期是這份 source 的發布日（取得日為次選）：

- `2026-04-02-fowler-harness-engineering.md`
- `2026-03-15-openai-codex-symphony.md`
- `2025-11-08-maganti-blog-post.md`

這個格式讓 `ls summaries/ | sort` 自然按時序排列，也能 `grep "^2026-04"` 找特定月份。

## 模板

```markdown
---
title: <Source 原標題>
type: summary
tags: [...]
sources:
  - ../../raw/<原始檔名>
updated: YYYY-MM-DD
author: <作者>
publication: <發布處>
publication_date: YYYY-MM-DD
url: https://...（如有）
---

# {{title}}

**作者**：... | **發布**：... | **日期**：YYYY-MM-DD | **長度**：~N 字 / N 頁

## TL;DR

3–5 條 bullet，每條 1 句話。看完這段就知道這份 source 在講什麼。

## 核心論點

更詳細的拆解，依原文邏輯結構排序。每段附原文引用或頁碼。

## 關鍵資料 / 數字

| 指標 | 數值 | 出處 |
|------|------|------|
| ... | ... | p.X |

## 我的提取（與本 wiki 主題的關聯）

這份 source 對 `{{TOPIC}}` wiki 的貢獻是什麼？哪些段落最值得反覆引用？

## ⚠️ Contradictions / Open Questions

- 與 [其他 source](xxx.md) 的衝突：...
- 文中沒講清楚、值得追查的：... → 已加入 [Open Questions](../syntheses/open-questions.md)

## 🔗 影響的 wiki 頁

ingest 這份 source 時，動到了：
- [實體 X](../entities/x.md) — 新增 / 補充段落 Y
- [概念 Z](../concepts/z.md) — 加入此 source 的視角
```

## 寫作要點

- **summary 是 source 的濃縮，不是評論**。觀點與綜合放 `syntheses/`、實體與概念放對應目錄。
- 引用必須能對回原 source（頁碼、章節、時間戳）。LLM 會被使用者抓包。
- 「影響的 wiki 頁」段落是給未來 lint 用的——將來想知道某概念頁的論述為什麼長那樣，回查 summary 就能找到 root。
