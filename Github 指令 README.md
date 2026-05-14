# Obsidian Vault

這是我的 Obsidian 筆記倉庫。

## 操作指令

### 1. 更新檔案 (Pull)
從雲端下載最新的筆記到本地：

```bash
git pull origin main
```

### 2. 上傳檔案 (Push)
將本地的新筆記上傳到雲端：

```bash
git add .
git commit -m "update: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main
```

---

## 其他常用指令

### 查看狀態
查看目前有哪些檔案有變動：

```bash
git status
```
