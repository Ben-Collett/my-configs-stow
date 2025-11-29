#!/usr/bin/env bash
set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <cursor_png> <pointer_png> <theme_name>"
    exit 1
fi

CURSOR_PNG="$1"
POINTER_PNG="$2"
THEME="$3"

THEME_DIR="$HOME/.local/share/icons/$THEME/cursors"

echo "[i] Creating theme at: $THEME_DIR"
mkdir -p "$THEME_DIR"

# --- Create cursor.theme metadata ---
cat > "$HOME/.local/share/icons/$THEME/cursor.theme" <<EOF
[Icon Theme]
Name=$THEME
Comment=Custom Hyprcursor Theme
Inherits=hyprcursor
EOF

# --- Create index.theme ---
cat > "$HOME/.local/share/icons/$THEME/index.theme" <<EOF
[Icon Theme]
Name=$THEME
Comment=Custom Cursor Theme
Directories=cursors

[cursors]
Size=32
EOF

# --- Symlink your PNGs to cursor names ---
# These names matter! Hyprland → wlroots → Xcursor names
echo "[i] Linking PNGs as cursor sprites..."

ln -sf "$CURSOR_PNG"  "$THEME_DIR/left_ptr.png"
ln -sf "$CURSOR_PNG"  "$THEME_DIR/default.png"

ln -sf "$POINTER_PNG" "$THEME_DIR/hand1.png"
ln -sf "$POINTER_PNG" "$THEME_DIR/hand2.png"

# You can add more if desired:
# ln -sf "$CURSOR_PNG" "$THEME_DIR/xterm.png"

# --- Set environment variable ---
echo "[i] Setting environment variable HYPRCURSOR_THEME"
export HYPRCURSOR_THEME="$THEME"

# Persist in ~/.config/hypr/hyprland.conf
if ! grep -q "HYPRCURSOR_THEME=" "$HOME/.config/hypr/hyprland.conf"; then
    echo -e "\n# Custom cursor theme\nenv = HYPRCURSOR_THEME,$THEME" >> "$HOME/.config/hypr/hyprland.conf"
    echo "[i] Added HYPRCURSOR_THEME to hyprland.conf"
fi

# --- Reload Hyprland ---
echo "[i] Reloading Hyprland..."
hyprctl reload

echo "[✓] Done! Cursor theme '$THEME' installed and applied."

