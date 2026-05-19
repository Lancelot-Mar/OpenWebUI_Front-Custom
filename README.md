# Frontend Customization Script — Guide

This script replaces the logos and app name of an **Open WebUI** installation with your own branding.

---

## What it does

| Step | Action |
|------|--------|
| 1 | Checks that ImageMagick is installed (installs it if not) |
| 2 | Verifies the source logo file exists |
| 3 | Creates a backup of all original logo files |
| 4 | Generates your logo in all required sizes |
| 5 | Syncs the logos to the second static folder |
| 6 | Replaces the app name in the environment file |
| 7 | Fixes file permissions and restarts the service |

---

## Before you start

Make sure you have:
- A Linux server with Open WebUI installed
- Root or sudo access
- Your logo in `.png` format (recommended minimum size: **512x512 px**)

---

## Configuration

Before running the script, open it and fill in the **6 variables** at the top:

```bash
STATIC_FRONTEND=""   # Path to the frontend static folder
                     # Example: /opt/openwebui/venv/lib/python3.12/site-packages/open_webui/frontend/static

STATIC_APP=""        # Path to the app static folder
                     # Example: /opt/openwebui/venv/lib/python3.12/site-packages/open_webui/static

BACKUP_DIR=""        # Where to save the original logo backups
                     # Example: /opt/openwebui/backup_logos

LOGO_FUENTE=""       # Full path to your custom logo (.png)
                     # Example: /home/user/my_logo.png

ARCHIVO_ENV=""       # Path to Open WebUI's env.py file
                     # Example: /opt/openwebui/venv/lib/python3.12/site-packages/open_webui/env.py

NOMBRE=""            # Your app/company name to replace "Open WebUI"
                     # Example: MyCompany
```

---

## How to run it

**1. Give the script execution permissions:**
```bash
chmod +x customize_frontend.sh
```

**2. Run it as root:**
```bash
sudo ./customize_frontend.sh
```

---

## Logo sizes generated

The script automatically resizes your logo into all the formats Open WebUI needs:

| File | Size | Used for |
|------|------|----------|
| `logo.png` | 512×512 | Main app logo |
| `favicon.png` | 96×96 | Browser tab icon |
| `favicon-96x96.png` | 96×96 | PWA icon |
| `favicon-dark.png` | 48×48 | Dark mode favicon |
| `favicon.ico` | 32×32 | Legacy browser favicon |
| `web-app-manifest-192x192.png` | 192×192 | Mobile home screen |
| `web-app-manifest-512x512.png` | 512×512 | Mobile splash screen |

---

## Changes made from original version

- **All variables left empty** — you must fill them in before running
- **Translated to English** — all comments, echo messages and labels
- **Added missing step 2 echo** — the original script was missing the section header for the logo check
- **Replaced hardcoded name** — `Gestelcom` replaced with the empty `NOMBRE` variable so the script is reusable for any project
- **Temp file renamed** — from `gestelcom_logo_original.png` to `custom_logo_original.png` to avoid hardcoded branding

---

## Restoring the originals

If something goes wrong, your original logos are saved in `BACKUP_DIR`. Copy them back manually:

```bash
cp /your/backup/dir/logo.png /path/to/static/frontend/logo.png
# Repeat for each file
systemctl restart openwebui
```

---

## After running

- **Clear your browser cache** with `Ctrl + Shift + R`
- Check the browser tab — it should show your new favicon
- Check the app — it should show your new logo and name
