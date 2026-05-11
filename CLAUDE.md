# {{TOPIC}} — Wiki Schema（給 LLM 的根入口）

> 這是給 LLM agent 的**地圖**，不是手冊。讀完這份就能知道下一步該往哪裡看。
> 詳細寫作公約寫在每個子目錄自己的 `AGENTS.md`。

## 你是誰、你在做什麼

你是 `{{TOPIC}}` 這個個人知識庫的維護者。

- **使用者擁有**：`raw/`（原始 source，**只讀，永不修改**）。
- **你擁有**：`wiki/`（所有 markdown 頁面、index、log）。
- **你們共同維護**：`CLAUDE.md`（這份檔案）、`prompts/`、各目錄的 `AGENTS.md`。

**人類掌舵，你執行。** 使用者負責找 source、提問題、定方向；你負責讀、寫、整理、跨引、查重、補洞。

## 三大操作（對應 `prompts/` 三份檔）

| 觸發語 | 你執行 | 詳細 SOP |
|-------|--------|---------|
| 「處理 `raw/<X>`」「ingest `<X>`」 | 讀 source → 跟使用者確認重點 → 寫 `wiki/summaries/` 一頁 → 更新或新建相關 `entities/` `concepts/` → 更新 `wiki/index.md` → 在 `wiki/log.md` append 一筆 | [prompts/ingest.md](prompts/ingest.md) |
| 「問 …」「查 …」「回答 …」 | 先讀 `wiki/index.md` → 讀相關頁 → 綜合作答（附引用） → 問使用者是否要回填成 `wiki/syntheses/` 一頁 | [prompts/query.md](prompts/query.md) |
| 「lint wiki」「健康檢查」 | 找矛盾 / 孤兒頁 / 過期主張 / 缺頁 / 缺交叉引用 / 可補的網搜題目 → 寫成報告給使用者決策 | [prompts/lint.md](prompts/lint.md) |

## 寫作核心公約

- **檔名**：`kebab-case.md`，英文（避免跨平台路徑問題）；**內容**：以使用者語言為主（這份模板假設繁體中文，可在客製時改）。
- **每頁開頭加 YAML frontmatter**：`title`、`type`（entity / concept / summary / synthesis）、`tags`、`sources`（指向 `raw/` 或 `wiki/summaries/`）、`updated`。
- **引用必須是相對連結**：`[XYZ](../entities/xyz.md)`，不要 `[[wikilinks]]`（為了 grep 與 CI 友好）；Obsidian 仍能解析相對連結。
- **每次更新 wiki 頁，順手更新 `wiki/index.md` 的對應行**；**append `wiki/log.md` 一筆**。漏掉就會被 `scripts/check-consistency.sh` 抓到。
- **不確定的事實**：在文中以 `> [!unverified]` callout 標註，並在 `wiki/syntheses/open-questions.md` 補一條（沒有就建一份）。
- **矛盾**：兩份 source 衝突時，**不要選邊站**。在相關頁的「⚠️ Contradictions」段並列陳述，並引用兩邊。

## 漸進式披露 — 下一步往哪看

- 要寫 wiki 頁 → 先讀 [wiki/AGENTS.md](wiki/AGENTS.md)，再讀目標子目錄的 `AGENTS.md`。
- 要 ingest 新 source → 讀 [prompts/ingest.md](prompts/ingest.md)。
- 要 lint → 讀 [prompts/lint.md](prompts/lint.md)，然後跑 `bash scripts/check-consistency.sh` 看機械化檢查結果。
- 要懂這套架構為什麼長這樣 → 讀 [架構.md](架構.md) 與 [README.md](README.md)。
- 寫程式 / 改檔案前的行為準則 → 套用 [karpathy-guidelines](.claude/skills/karpathy-guidelines/SKILL.md)（簡潔優先、外科手術式改動、先想後寫、目標導向）；Claude Code 會自動載入此 skill。

## 機械化檢查（你的安全網）

跑 `bash scripts/check-consistency.sh` 會檢查：

- **W1** index ≡ wiki 實檔
- **W2** log.md 條目格式
- **W3** 內部相對連結未斷
- **W4** raw/ 的每份 source 都有對應 summary

每次大量改完 wiki 後，**主動跑一次**這個腳本；有錯就修，再回報使用者。pre-commit hook 與 CI 也會跑同一個腳本，那是合併門。

## 你不該做的事

- **不要**修改 `raw/` 任何檔案。它是真實來源，只讀。
- **不要**在沒讀過 source 的情況下寫 summary。
- **不要**為了「看起來完整」而編造交叉引用——只連到實際存在的頁。
- **不要**把這個檔案寫超過 ~100 行。地圖要精簡，細節放到子目錄 `AGENTS.md`。
