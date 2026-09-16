#!/bin/bash

# ============================================================
# Fastfetch Random Waifu - macOS / Kitty edition
#
# Image source:
#   https://nekos.best/api/v2/waifu
#
# Dependencies:
#   fastfetch
#   curl
#   jq
#   file
#
# Usage:
#   fastfetch-random-waifu.sh
#   fastfetch-random-waifu.sh [fastfetch arguments]
# ============================================================

# ================= Configuration =================

# Number of images downloaded whenever stock is low
DOWNLOAD_BATCH_SIZE=5

# Maximum number of unused images
MAX_CACHE_LIMIT=20

# Download more images when stock falls below this value
MIN_TRIGGER_LIMIT=10

# Maximum number of previously used images to keep
MAX_USED_LIMIT=20

# Clean Fastfetch's generated image cache after running
CLEAN_CACHE_MODE=true

# ================= Directories =================

CACHE_DIR="$HOME/.cache/fastfetch_waifu"
USED_DIR="$CACHE_DIR/used"

mkdir -p "$CACHE_DIR"
mkdir -p "$USED_DIR"

# ================= Dependency check =================

REQUIRED_COMMANDS=(fastfetch curl jq file)

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: required command '$cmd' was not found."
        echo "Please install it before using ff."
        exit 1
    fi
done

# ================= Functions =================
USER_AGENT="ffw (123)"

get_random_url() {
    curl -fsSL \
        --connect-timeout 5 \
        --max-time 15 \
        -A "$USER_AGENT" \
        "https://nekos.best/api/v2/waifu" |
        jq -r '.results[0].url // empty'
}

download_one_image() {
    local url
    local filename
    local target_path
    local mime

    url="$(get_random_url)"

    # Make sure API actually returned a URL
    if [[ ! "$url" =~ ^https?:// ]]; then
        return 1
    fi

    # macOS-compatible unique filename
    filename="waifu_$(date +%s)_${RANDOM}_$$.img"
    target_path="$CACHE_DIR/$filename"

    # Download image
    if ! curl -fsSL \
        --connect-timeout 5 \
        --max-time 30 \
        -A "$USER_AGENT" \
        -o "$target_path" \
        "$url"; then
        rm -f "$target_path"
        return 1
    fi

    # Verify that downloaded file is actually an image
    if [ ! -s "$target_path" ]; then
        rm -f "$target_path"
        return 1
    fi

    mime="$(file -b --mime-type "$target_path")"

    case "$mime" in
    image/jpeg)
        mv "$target_path" "${target_path%.img}.jpg"
        ;;
    image/png)
        mv "$target_path" "${target_path%.img}.png"
        ;;
    image/webp)
        mv "$target_path" "${target_path%.img}.webp"
        ;;
    image/gif)
        mv "$target_path" "${target_path%.img}.gif"
        ;;
    image/*)
        mv "$target_path" "${target_path%.img}.image"
        ;;
    *)
        rm -f "$target_path"
        return 1
        ;;
    esac
}

count_images() {
    find "$1" \
        -maxdepth 1 \
        -type f \
        \( -name "*.jpg" \
        -o -name "*.jpeg" \
        -o -name "*.png" \
        -o -name "*.webp" \
        -o -name "*.gif" \
        -o -name "*.image" \) \
        2>/dev/null |
        wc -l |
        tr -d ' '
}

background_job() {
    local current_count
    local oldest

    current_count="$(count_images "$CACHE_DIR")"

    # Refill cache when stock is low
    if [ "$current_count" -lt "$MIN_TRIGGER_LIMIT" ]; then
        for ((i = 1; i <= DOWNLOAD_BATCH_SIZE; i++)); do
            download_one_image
            sleep 0.3
        done
    fi

    # Remove oldest images if cache becomes too large
    while [ "$(count_images "$CACHE_DIR")" -gt "$MAX_CACHE_LIMIT" ]; do
        oldest="$(
            find "$CACHE_DIR" \
                -maxdepth 1 \
                -type f \
                ! -name ".*" \
                -print0 |
                xargs -0 ls -tr 2>/dev/null |
                head -n 1
        )"

        [ -n "$oldest" ] && rm -f "$oldest" || break
    done
}

get_random_image() {
    local files=()

    while IFS= read -r -d '' file_path; do
        files+=("$file_path")
    done < <(
        find "$CACHE_DIR" \
            -maxdepth 1 \
            -type f \
            ! -name ".*" \
            -print0
    )

    local count="${#files[@]}"

    if [ "$count" -eq 0 ]; then
        return 1
    fi

    printf '%s\n' "${files[$((RANDOM % count))]}"
}

clean_used_images() {
    while [ "$(count_images "$USED_DIR")" -gt "$MAX_USED_LIMIT" ]; do
        oldest="$(
            find "$USED_DIR" \
                -maxdepth 1 \
                -type f \
                ! -name ".*" \
                -print0 |
                xargs -0 ls -tr 2>/dev/null |
                head -n 1
        )"

        [ -n "$oldest" ] && rm -f "$oldest" || break
    done
}

# ================= Main =================

SELECTED_IMG="$(get_random_image)"

# No cached images yet
if [ -z "$SELECTED_IMG" ] || [ ! -f "$SELECTED_IMG" ]; then
    echo "No cached waifu yet — downloading initial batch..."

    for ((i = 1; i <= DOWNLOAD_BATCH_SIZE; i++)); do
        download_one_image
        sleep 0.3
    done

    SELECTED_IMG="$(get_random_image)"
fi

# Start cache refill in background
background_job >/dev/null 2>&1 &

# ================= Fastfetch =================

if [ -n "$SELECTED_IMG" ] && [ -f "$SELECTED_IMG" ]; then

    # Get original image dimensions
    IMG_WIDTH=$(sips -g pixelWidth "$SELECTED_IMG" 2>/dev/null | awk '/pixelWidth/ {print $2}')
    IMG_HEIGHT=$(sips -g pixelHeight "$SELECTED_IMG" 2>/dev/null | awk '/pixelHeight/ {print $2}')

    # Maximum display size
    MAX_LOGO_WIDTH=30
    MAX_LOGO_HEIGHT=26

    # First, calculate size based on maximum width
    LOGO_WIDTH=$MAX_LOGO_WIDTH
    LOGO_HEIGHT=$(( LOGO_WIDTH * IMG_HEIGHT * 10 / IMG_WIDTH / 19 ))

    # If the image becomes too tall, limit height instead
    if [ "$LOGO_HEIGHT" -gt "$MAX_LOGO_HEIGHT" ]; then
        LOGO_HEIGHT=$MAX_LOGO_HEIGHT
        LOGO_WIDTH=$(( LOGO_HEIGHT * IMG_WIDTH * 19 / IMG_HEIGHT / 10 ))
    fi
    

    fastfetch \
        --kitty-direct "$SELECTED_IMG" \
        --logo-width "$LOGO_WIDTH" \
        --logo-height "$LOGO_HEIGHT" \
        --logo-preserve-aspect-ratio true \
        --logo-padding-top 2 \
        --logo-padding-left 2 \
    #    --show-errors \
        "$@"

    # Archive image after use
    mv "$SELECTED_IMG" "$USED_DIR/"

    clean_used_images

    if [ "$CLEAN_CACHE_MODE" = true ]; then
        rm -rf "$HOME/.cache/fastfetch/images"
    fi

else

    echo "Image download failed — using the default Fastfetch logo."
    fastfetch "$@"

fi
