# Obsidian 圖片附件設定 recipe

把這份檔丟給 AI，它就能在另一個 Obsidian vault 重現一樣的圖片附件管理方式。

## 目的

讓貼到筆記裡的圖片**自動分類存放**，並且寫出**標準 Markdown 連結**（GitHub / VSCode / 任何 IDE 都能預覽），不依賴 Obsidian wikilink 解析。

## 預期效果

| 筆記位置 | 圖片自動存到 | 寫進筆記的連結 |
|---|---|---|
| `1-raw/某筆記.md` | `1-raw-photo/某筆記/file-時戳.png` | `![](../1-raw-photo/某筆記/file-時戳.png)` |
| `1-raw/日本/東京.md` | `1-raw-photo/日本/東京/file-時戳.png` | `![](../../1-raw-photo/日本/東京/file-時戳.png)` |
| `1-raw/Stock/某股.md` | `1-raw-photo/Stock/某股/file-時戳.png` | `![](../../1-raw-photo/Stock/某股/file-時戳.png)` |
| 其他資料夾的筆記 | `<該資料夾>/assets/<筆記名>/` | （相對路徑，由 Obsidian 自動算） |

設計重點：
- `1-raw/` 底下的筆記，圖片**鏡射到 `1-raw-photo/`** 對應子路徑，每篇再開一層**筆記同名子資料夾**，方便人眼一次看清「這張圖屬於哪篇」。
- 其他資料夾走 fallback 規則（圖片放在筆記旁邊的 `assets/` 子資料夾）。
- 全部用標準 Markdown `![](相對路徑)` 語法，GitHub / IDE 直接渲染。

## 步驟

### 1. 安裝外掛

在 Obsidian 內：`Settings → Community plugins → Browse`，搜尋並安裝：

- **Custom Attachment Location**（作者：mnaoumov，建議版本 `>=10.3.4`）

安裝後**啟用**它。

### 2. 設定 Custom Attachment Location 外掛

外掛設定檔路徑：`<vault>/.obsidian/plugins/obsidian-custom-attachment-location/data.json`

直接覆寫成下面這份（**或**在 Obsidian UI `Settings → Custom Attachment Location` 內逐欄填同樣的值）：

```json
{
  "attachmentFolderPath": "${attachmentDest}",
  "attachmentRenameMode": "Only pasted images",
  "collectAttachmentUsedByMultipleNotesMode": "Skip",
  "collectedAttachmentFileName": "",
  "convertImagesToJpegMode": "None",
  "customTokensStr": "registerCustomToken('attachmentDest', (ctx) => {\n  const folder = ctx.noteFolderPath ?? '';\n  const name = ctx.noteFileName;\n  // 1-raw/ 底下的筆記：鏡射到 1-raw-photo/，並再開一層筆記同名資料夾\n  if (folder === '1-raw' || folder.startsWith('1-raw/')) {\n    const sub = folder.replace(/^1-raw(\\/|$)/, '');\n    return sub ? `1-raw-photo/${sub}/${name}` : `1-raw-photo/${name}`;\n  }\n  // 其他資料夾：fallback 行為\n  return `${folder}/assets/${name}`;\n});\n",
  "defaultImageSize": "",
  "defaultImageSizeDimension": "width",
  "duplicateNameSeparator": " ",
  "emptyFolderBehavior": "DeleteWithEmptyParents",
  "excludePaths": [],
  "excludePathsFromAttachmentCollecting": [],
  "generatedAttachmentFileName": "file-${date:{momentJsFormat:'YYYYMMDDHHmmssSSS'}}",
  "includePaths": [],
  "jpegQuality": 0.8,
  "markdownUrlFormat": "",
  "moveAttachmentToProperFolderUsedByMultipleNotesMode": "CopyAll",
  "renamedAttachmentFileName": "",
  "shouldDeleteOrphanAttachments": false,
  "shouldHandleRenames": true,
  "shouldRenameAttachmentFiles": false,
  "shouldRenameAttachmentFolder": true,
  "shouldRenameCollectedAttachments": false,
  "specialCharacters": "#^[]|*\\<>:?/",
  "specialCharactersReplacement": "-",
  "timeoutInSeconds": 5,
  "treatAsAttachmentExtensions": [
    ".excalidraw.md"
  ],
  "version": "10.3.4"
}
```

關鍵欄位解釋：

| 欄位 | 值 | 作用 |
|---|---|---|
| `attachmentFolderPath` | `${attachmentDest}` | 引用下方自訂 token |
| `customTokensStr` | 上面那段 JS | 定義 `attachmentDest` token：根據筆記位置動態決定要去哪 |
| `generatedAttachmentFileName` | `file-${date:...}` | 貼進來的圖檔自動改名為 `file-YYYYMMDDHHmmssSSS` |
| `shouldRenameAttachmentFolder` | `true` | 改筆記名 → 附件資料夾跟著改 |
| `shouldHandleRenames` | `true` | 搬筆記 → 附件跟著搬 |

如果 vault 沒有 `1-raw/` 這個資料夾、或想改成別的路徑，**把 token 裡的 `1-raw` 和 `1-raw-photo` 換成你要的名字即可**。

### 3. 設定 Obsidian 全域連結格式

設定檔路徑：`<vault>/.obsidian/app.json`

把它寫成（或合併進去）：

```json
{
  "useMarkdownLinks": true,
  "newLinkFormat": "relative"
}
```

- `useMarkdownLinks: true` → 新貼圖寫成 `![](path)` 而不是 `![[...]]`
- `newLinkFormat: "relative"` → 連結是**相對於 .md 檔的路徑**（GitHub / IDE 才能正確解析）

或在 Obsidian UI 改：`Settings → Files and links`：
- `Use [[Wikilinks]]` → **OFF**
- `New link format` → **Relative path to file**

### 4. 重新載入

直接寫設定檔的話，Obsidian 已經把舊設定快取在記憶體裡，必須重載：

- `Ctrl + R`
- 或 command palette → `Reload app without saving`
- 或把 Custom Attachment Location 外掛關掉再開回來

## 驗證

重載後做一次測試：

1. 在 `1-raw/` 新建一篇筆記，例如 `test.md`，貼一張圖
   - 圖檔應該出現在 `1-raw-photo/test/file-時戳.png`
   - 筆記裡的連結應該是 `![](../1-raw-photo/test/file-時戳.png)`
2. 在 `1-raw/Stock/` 新建 `某股.md`，貼一張圖
   - 圖檔應該出現在 `1-raw-photo/Stock/某股/file-時戳.png`
   - 連結應該是 `![](../../1-raw-photo/Stock/某股/file-時戳.png)`
3. push 到 GitHub 或在 VSCode 預覽 → 圖片應該正常渲染

## Trade-off / 注意事項

- **`useMarkdownLinks: true` 是全域設定**：以後你打 `[[筆記名]]` 連到別篇筆記時，Obsidian 也會自動寫成 `[筆記名](相對路徑.md)`。**舊的 wikilink 不會被改**，Obsidian 仍能正常解析。若只想讓附件用 markdown link、note 之間保留 wikilink，改用外掛的 `markdownUrlFormat` 設定 + 寫一個自己算相對路徑的 custom token（較複雜）。
- **既有圖片不會自動搬家**：本設定只影響**之後**的貼圖。要搬舊圖，需手動 `mv` + 改連結。
- **`1-raw-photo/` 不需事先建立**：Obsidian 貼圖時會自動建。
- **路徑中含中文 / 空白**：標準 Markdown 連結需要 URL encode 空白（`%20`），Obsidian 寫出來會自動處理。

## 給其他 AI 的執行提示

如果你（AI）要在另一個 vault 套這份設定：

1. 先確認 vault 根目錄（含 `.obsidian/` 資料夾的那層）
2. 確認 `Custom Attachment Location` 外掛已安裝（`.obsidian/plugins/obsidian-custom-attachment-location/` 存在）
   - 沒裝就請使用者去 Community plugins 安裝
3. 讀現有的 `data.json`、**只動 `attachmentFolderPath` 和 `customTokensStr` 兩個欄位**，其他保留使用者原值
4. 讀現有的 `app.json`、merge `useMarkdownLinks` + `newLinkFormat` 兩個 key，不要覆蓋其他設定
5. 提醒使用者重載 Obsidian
6. 如果 vault 的「原料資料夾」不叫 `1-raw/`、「圖片資料夾」不叫 `1-raw-photo/`，先問使用者要用什麼名字，再對應修改 token 裡的字串
