rcd() {
    # Use /tmp as the globally writable directory
    local dir="/tmp/$(uuidgen)"
    mkdir -p "$dir"
    cd "$dir"
}

