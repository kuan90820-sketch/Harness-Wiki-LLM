# Wiki Log

> Append-only 時序紀錄。**只新增，不刪改**（除非格式錯需修正）。
> 每行格式：`## [YYYY-MM-DD] <op> | <subject>`，後面接 1–3 句話描述。
>
> 可解析範例：`grep "^## \[" wiki/log.md | tail -10` 看最近 10 筆。

<!--
操作類型（op）：
  - ingest  — 新增一份 source 並整合進 wiki
  - query   — 使用者提問，產出綜合分析
  - lint    — 健康檢查與修正
  - update  — 一般小幅更新（補資料、修錯字、加交叉引用）
  - schema  — 修改 CLAUDE.md / AGENTS.md / 子目錄公約

機械化檢查：所有 `## ` 開頭的標題都必須符合 `## [YYYY-MM-DD] <op> | <subject>` 格式。
-->

## [2026-05-05] schema | 模板初始化

從 `架構.md`（LLM Wiki）+ `deusyu/harness-engineering`（Harness Engineering）兩份資料合併出此模板。建立三層結構（raw / wiki / schema）、漸進式 AGENTS.md、機械化檢查（W1–W4）。
