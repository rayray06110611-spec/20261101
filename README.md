# 小柯攝影工作室｜作品集網站

臺中婚紗、婚禮紀錄、形象照攝影師的單頁作品集網站。純 HTML + CSS（寫在同一個 `index.html`），不需要任何建置工具，可直接部署到 Vercel。

## 專案結構

```
xiaoke-photo/
├── index.html            ← 整個網站（HTML + CSS + 少量 JS）
├── images/               ← 所有圖片
│   ├── hero.jpg / about.jpg
│   ├── wedding-01 ~ 06.jpg     婚紗
│   ├── ceremony-01 ~ 06.jpg    婚禮紀錄
│   └── portrait-01 ~ 06.jpg    形象照
├── google-apps-script/
│   └── Code.gs           ← 表單後端：寫入 Google 試算表＋寄通知信（貼到 Apps Script 用）
├── download-images.sh    ← 一鍵下載 Unsplash 免費示意圖
├── vercel.json           ← Vercel 設定（快取、乾淨網址）
└── README.md
```

## 第 0 步：換上真正的照片

`images/` 裡目前是**佔位圖**（柔和漸層色塊），讓你一打開就能看到版面。換成照片有兩種方式：

1. **一鍵下載免費圖庫照片**（Mac / Linux / Windows 的 Git Bash）：
   ```bash
   bash download-images.sh
   ```
   圖片來自 [Unsplash](https://unsplash.com/license)，可免費商用、不需標註。若有幾張失敗或主題不合，到 Unsplash 或 [Pexels](https://www.pexels.com/zh-tw/) 搜尋 `wedding couple`、`wedding ceremony`、`portrait natural light` 手動下載並**用相同檔名**覆蓋即可。
2. **換成攝影師自己的作品**（正式上線一定要這樣做）：直接用同檔名覆蓋，建議長邊 1600px、JPG 品質 80，單張控制在 400KB 內。

> 換照片後，記得順手檢查 `index.html` 裡對應的 `alt` 文字是否還描述正確——alt 是 SEO 與視障使用者的重要資訊。

## 第 1 步：上傳到 GitHub

**方法 A：網頁上傳（不用指令）**
1. 登入 GitHub → 右上 `+` → **New repository**，名稱例如 `xiaoke-photo`，選 Public，按 Create。
2. 在新 repo 頁面點 **uploading an existing file**，把 `index.html`、`images` 資料夾、`vercel.json`、`README.md` 一起拖進去 → **Commit changes**。

**方法 B：Git 指令**
```bash
cd xiaoke-photo
git init
git add .
git commit -m "first commit: 小柯攝影作品集"
git branch -M main
git remote add origin https://github.com/你的帳號/xiaoke-photo.git
git push -u origin main
```

## 第 2 步：部署到 Vercel

1. 到 [vercel.com](https://vercel.com) 用 GitHub 帳號登入。
2. **Add New → Project** → 選剛剛的 `xiaoke-photo` → **Import**。
3. Framework Preset 選 **Other**，Build Command 與 Output Directory **都留空** → **Deploy**。
4. 約 30 秒後會得到網址，例如 `https://xiaoke-photo.vercel.app`。

之後每次 push 到 GitHub，Vercel 會自動重新部署。

## 第 3 步：上線後要改的地方

在 `index.html` 搜尋並替換：

| 搜尋 | 改成 |
|---|---|
| `https://xiaoke-photo.vercel.app/` | 你實際的網址（canonical） |
| `hello@xiaoke-photo.tw` | 真實 Email |
| `xiaoke.photo` | 真實 Instagram 帳號 |
| 方案價格、交件天數 | 實際報價 |

## 第 4 步：詢問表單串接 Google 試算表 + Email 通知

運作方式：

```
客戶在網站送出表單 ──fetch POST──▶ Google Apps Script（Code.gs）
                                      ├─▶ 新增一列到 Google 試算表「詢問單」
                                      └─▶ 寄「新詢問通知」到你指定的 Email
```

整個流程免費，不需要另外架伺服器。設定約 10 分鐘：

**A. 建立試算表與程式**
1. 到 [Google 試算表](https://sheets.google.com) 新增一份空白試算表，命名例如「小柯攝影｜詢問單」。
2. 選單 **擴充功能 → Apps Script**，會開啟程式編輯器。
3. 刪掉預設的程式碼，把本專案 `google-apps-script/Code.gs` 的內容**整份貼上**。
4. 修改最上方設定區的 `NOTIFY_EMAIL`，改成你要收通知的信箱（多個信箱用逗號分隔）。
5. 按 💾 儲存。

**B. 授權與測試**
1. 上方函式下拉選單選 `setupAndTest`，按 **▶ 執行**。
2. 第一次會要求授權：選你的 Google 帳號 →「進階」→「前往（不安全）」→「允許」。
   （這是你自己寫的程式，Google 未審核所以會出現警告，屬於正常現象。）
3. 執行完成後，試算表會多一個「詢問單」工作表（已有表頭），信箱也會收到一封測試信。

**C. 部署成網頁應用程式**
1. 右上角 **部署 → 新增部署作業**，齒輪選 **網頁應用程式**。
2. 設定：
   - 執行身分：**我**
   - 誰可以存取：**所有人**（⚠️ 一定要選這個，否則網站送不進來）
3. 按「部署」，複製**網頁應用程式網址**（`https://script.google.com/macros/s/……/exec`）。
4. 可先把網址貼到瀏覽器打開，看到「詢問表單服務運作中 ✓」就代表成功。

**D. 把網址貼回網站**
1. 打開 `index.html`，搜尋 `GAS_URL`，把 `https://script.google.com/macros/s/請貼上你的部署ID/exec` 換成剛剛複製的網址。
2. 存檔、推到 GitHub，Vercel 會自動重新部署。
3. 到正式網站送一筆測試，確認試算表多了一列、信箱收到通知。

**試算表欄位**：送出時間｜姓名｜聯絡方式｜拍攝類型｜預計日期｜拍攝地點｜預算｜留言｜處理狀態（下拉選單：未回覆／已回覆／已報價／已成交／未成交）｜備註

**常見問題**

| 狀況 | 原因與解法 |
|---|---|
| 網站顯示「送出失敗」 | 部署時「誰可以存取」沒選**所有人**；或 `GAS_URL` 貼錯（結尾要是 `/exec`，不是 `/dev`） |
| 改了 Code.gs 但沒有生效 | 需要 **部署 → 管理部署作業 → ✏️ 編輯 → 版本選「新版本」→ 部署**。這樣網址不變，只更新程式 |
| 有寫入試算表但沒收到信 | 檢查 `NOTIFY_EMAIL` 與垃圾郵件匣；在 Apps Script 左側「執行作業」可看錯誤紀錄 |
| 寄信數量上限 | 一般 Gmail 帳號每天約 100 封，Google Workspace 帳號約 1,500 封，攝影工作室的用量通常足夠 |

**內建的保護**
- 隱藏的防垃圾欄位（honeypot）：機器人填了就不會被記錄。
- 長度限制與必填檢查在後端再做一次，不只依賴前端。
- 開頭是 `=`、`+`、`-`、`@` 的內容會被當作文字儲存，避免有人在試算表裡注入公式。
- 客戶若留 Email，通知信直接按「回覆」就會回到客戶信箱。
- 即使寄信失敗，資料仍會先存進試算表，不會遺失。

## 教學重點：這個網站用了哪些技巧

- **語義化標籤**：`header` / `nav` / `main` / `section` / `article` / `footer`，每個 `section` 用 `aria-labelledby` 對應標題。
- **SEO**：`<title>`、`meta description`、canonical、Open Graph、JSON-LD 結構化資料（ProfessionalService）、每張圖都有描述性 `alt`。
- **效能**：首屏圖 `fetchpriority="high"`，其餘 `loading="lazy"`；圖片設 `width`/`height` 避免版面跳動。
- **RWD**：作品集 `grid-template-columns` — 桌機 3 欄 → `max-width: 1024px` 平板 2 欄 → `max-width: 768px` 手機 1 欄。
- **可及性**：鍵盤焦點樣式、`aria-pressed` 篩選按鈕、`aria-live` 表單訊息、尊重 `prefers-reduced-motion`。
