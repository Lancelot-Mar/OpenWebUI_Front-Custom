#!/bin/bash

# ── Output colors ────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No color

# ── Configuration ────────────────────────────────────────────
STATIC_FRONTEND=""
STATIC_APP=""
BACKUP_DIR=""
LOGO_FUENTE=""
ARCHIVO_ENV=""
NOMBRE=""

echo ""
echo -e "${RED}───────────| Customize Frontend |───────────${NC}"
echo ""

# ── Check ImageMagick ────────────────────────────────────────
echo -e "${YELLOW}[1/7] Checking ImageMagick...${NC}"
if ! command -v convert &> /dev/null; then
    echo "ImageMagick not found. Installing..."
    apt install -y imagemagick &> /dev/null
    echo -e "  ${GREEN} ImageMagick installed${NC}"
else
    echo -e "  ${GREEN} ImageMagick available${NC}"
fi

# ── Check logo source file ───────────────────────────────────
echo ""
echo -e "${YELLOW}[2/7] Checking logo source file...${NC}"
if [ ! -f "$LOGO_FUENTE" ]; then
    echo -e "  ${RED} File not found: $LOGO_FUENTE${NC}"
    exit 1
fi
echo -e "  ${GREEN} Logo found: $LOGO_FUENTE${NC}"

# ── Backup originals ─────────────────────────────────────────
echo ""
echo -e "${YELLOW}[3/7] Backing up original logos...${NC}"
mkdir -p "$BACKUP_DIR"

for f in logo.png favicon.png favicon-96x96.png favicon.ico favicon.svg favicon-dark.png \
          web-app-manifest-192x192.png web-app-manifest-512x512.png; do
    if [ -f "$STATIC_FRONTEND/$f" ] && [ ! -f "$BACKUP_DIR/$f" ]; then
        cp "$STATIC_FRONTEND/$f" "$BACKUP_DIR/$f"
        echo "  Backed up: $f"
    fi
done
echo -e "  ${GREEN} Backup saved to $BACKUP_DIR${NC}"

# ── Generate all sizes ───────────────────────────────────────
echo ""
echo -e "${YELLOW}[4/7] Generating logos in all sizes...${NC}"

TMP="/tmp/custom_logo_original.png"
cp "$LOGO_FUENTE" "$TMP"

convert "$TMP" -resize 512x512  "$STATIC_FRONTEND/logo.png"
echo "  logo.png                     → 512x512"

convert "$TMP" -resize 96x96    "$STATIC_FRONTEND/favicon.png"
echo "  favicon.png                  → 96x96"

convert "$TMP" -resize 96x96    "$STATIC_FRONTEND/favicon-96x96.png"
echo "  favicon-96x96.png            → 96x96"

convert "$TMP" -resize 48x48    "$STATIC_FRONTEND/favicon-dark.png"
echo "  favicon-dark.png             → 48x48"

convert "$TMP" -resize 32x32    "$STATIC_FRONTEND/favicon.ico"
echo "  favicon.ico                  → 32x32"

convert "$TMP" -resize 192x192  "$STATIC_FRONTEND/web-app-manifest-192x192.png"
echo "  web-app-manifest-192x192.png → 192x192"

convert "$TMP" -resize 512x512  "$STATIC_FRONTEND/web-app-manifest-512x512.png"
echo "  web-app-manifest-512x512.png → 512x512"

# ── Sync second static folder ────────────────────────────────
echo ""
echo -e "${YELLOW}[5/7] Syncing /static folder...${NC}"
if [ -d "$STATIC_APP" ]; then
    cp "$STATIC_FRONTEND/logo.png"    "$STATIC_APP/logo.png"
    cp "$STATIC_FRONTEND/favicon.png" "$STATIC_APP/favicon.png"
    cp "$STATIC_FRONTEND/favicon.ico" "$STATIC_APP/favicon.ico"
    echo -e "  ${GREEN} Synced $STATIC_APP${NC}"
else
    echo "  Folder $STATIC_APP not found, skipping"
fi

# ── Change app name ──────────────────────────────────────────
echo ""
echo -e "${YELLOW}[6/7] Changing app name...${NC}"

cp "$ARCHIVO_ENV" "${ARCHIVO_ENV}.bak"
echo "  Backup created: ${ARCHIVO_ENV}.bak"

sed -i "s/Open WebUI/${NOMBRE}/g" "$ARCHIVO_ENV"

echo "  Result:"
grep -n "$NOMBRE" "$ARCHIVO_ENV"

# ── Fix permissions and restart ──────────────────────────────
echo ""
echo -e "${YELLOW}[7/7] Fixing permissions and restarting service...${NC}"

chown openwebui:openwebui \
    "$STATIC_FRONTEND/logo.png" \
    "$STATIC_FRONTEND/favicon.png" \
    "$STATIC_FRONTEND/favicon-96x96.png" \
    "$STATIC_FRONTEND/favicon.ico" \
    "$STATIC_FRONTEND/favicon-dark.png" \
    "$STATIC_FRONTEND/web-app-manifest-192x192.png" \
    "$STATIC_FRONTEND/web-app-manifest-512x512.png" \
    "$STATIC_APP/logo.png" \
    "$STATIC_APP/favicon.png" \
    "$STATIC_APP/favicon.ico" 2>/dev/null

chmod 644 \
    "$STATIC_FRONTEND/logo.png" \
    "$STATIC_FRONTEND/favicon.png" \
    "$STATIC_FRONTEND/favicon-96x96.png" \
    "$STATIC_FRONTEND/favicon.ico" \
    "$STATIC_APP/logo.png" \
    "$STATIC_APP/favicon.png" \
    "$STATIC_APP/favicon.ico" 2>/dev/null

echo -e "  ${GREEN} Permissions fixed${NC}"

systemctl restart openwebui
echo -e "  ${GREEN} Service restarted${NC}"

# ── Summary ──────────────────────────────────────────────────
echo ""
echo "Installation complete"
echo ""
echo "  Clear your browser cache (Ctrl+Shift+R)"
echo "  Backup located at: $BACKUP_DIR"
echo ""
