# prompts/

存放**經過驗證的工作流提示詞**。三份核心提示詞對應三大操作：

| 檔案 | 對應操作 | 何時用 |
|------|---------|--------|
| [ingest.md](ingest.md) | Ingest | 把新 source 整合進 wiki |
| [query.md](query.md) | Query | 針對 wiki 提問並（可選）回填新頁 |
| [lint.md](lint.md) | Lint | 定期健康檢查與重構建議 |

## 慣例

- 每份 prompt 都應該**自成單元**——複製貼到任何 LLM agent 就能用。
- 開頭包含明確的「你的角色」「你要做什麼」「不要做什麼」「成功標準」「輸出格式」。
- 變更 prompt 時，順手在 `wiki/log.md` 補一筆 `## [date] schema | prompts/<file>.md — <改了什麼>`。

## 擴充

當你發現某類提問值得固定下來，在這裡加新的 prompt 檔。例：
- `compare.md` — A vs B 比較表的標準產出
- `timeline.md` — 從多份 source 抽時序事件
- `survey.md` — 對某主題做文獻綜述
