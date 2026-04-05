# Deploy PocketDev website + APK to GitHub

The marketing site lives in **`website/`** (`index.html`, `privacy.html`, `terms.html`). Release APKs go under **`website/releases/`**.

## 1. Put the latest APK in place

1. Build a **signed release** APK in Android Studio (or your CI).
2. Copy the file to:  
   **`website/releases/PocketDev_AI_Android_V4.9.4.apk`**  
   (update the version in the filename when you ship a new build, and update the same filename in **`index.html`** where the APK link appears.)
3. Commit when you want that build public. Large APKs: use **Git LFS** (`git lfs track "*.apk"`) if GitHub rejects the push.

Links on the site use a **relative** path: **`releases/PocketDev_AI_Android_V4.9.4.apk`** (from `index.html`).

**Important:** Tell users to prefer **Google Play** for **in-app purchases** (wallet top-ups). Sideloaded APKs cannot use Google Play Billing the same way.

## 2. Push to GitHub (easiest)

On Windows, open **PowerShell** in the **`website`** folder and run:

```powershell
.\deploy-to-github.ps1
```

Or double-click **`deploy-to-github.bat`**. The script finds Git, commits this folder, and pushes to **`engrzubairshabbir/pocketdevapp.com`** on branch **`main`**.

**You must log in to GitHub once** (browser or Personal Access Token) when `git push` asks — nobody can do that for you.

Manual equivalent:

```bash
cd website
git add -A
git commit -m "Update site"
git push origin main
```

## 3. Publish with GitHub Pages

**Option A — Site from `/website` folder**

1. Repo → **Settings** → **Pages**.
2. **Build and deployment** → Source: **Deploy from a branch**.
3. Branch: your default branch, folder: **`/website`** (or `/docs` if you moved files there).
4. Save. After a minute, the site is at  
   `https://<username>.github.io/<repo>/`  
   (or your custom domain if configured).

**Option B — Custom domain (e.g. pocketdevapp.com)**

1. In **Pages**, set **Custom domain** to your domain.
2. At your DNS host, add the records GitHub shows (usually `A` / `CNAME` for `www`).
3. Wait for DNS + HTTPS certificate (can take up to an hour).

## 4. After each release

1. Add or replace **`website/releases/PocketDev_AI_Android_VX.Y.Z.apk`** and update **`index.html`** if the filename changed.
2. Bump **`app/build.gradle.kts`** `versionName` / `versionCode` for Play as usual.
3. Commit + push. Play users update via Play; the site APK link is for advanced users only.

## 5. Play Store stays the source of truth for IAP

**Listing URL (stable):**  
`https://play.google.com/store/apps/details?id=com.pocketdev.ai.appbuilder`
