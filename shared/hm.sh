dir="$HOME/.config/home-manager"

_get_os() {
  os=$(uname -o)
  case "$os" in
  "GNU/Linux")
    echo "linux"
    ;;
  "Darwin")
    echo "macos"
    ;;
  *)
    echo "Unknown OS: $os"
    exit 1
    ;;
  esac
}

_handle_update() {
  pushd "$dir" &>/dev/null || {
    echo "Failed to change to directory: $dir"
    return 1
  }
  git pull || {
    echo "Failed to execute git pull"
    return 1
  }
  nix flake update || {
    echo "Failed to execute nix flake"
    return 1
  }
  popd &>/dev/null
}

_handle_edit() {
  pushd "$dir" || {
    echo "Failed to change to directory: $dir"
    return 1
  }
  eval $EDITOR $HOME/.config/home-manager
  popd
}

_handle_switch() {
  option=$(_get_os)
  home-manager switch -b backup --flake ~/.config/home-manager#"plumps@$option" || {
    echo "Failed to execute nixos-rebuild switch"
    return 1
  }
}

hm() {
  if [ "$#" -ne 1 ]; then
    cat "$dir/README.md"
    return 1
  fi

  case "$1" in
  "switch")
    _handle_switch
    ;;
  "edit")
    _handle_edit
    ;;
  "update")
    _handle_update
    ;;
  "rebuild")
    _handle_update
    _handle_switch
    ;;
  *)
    echo "Usage: hm [edit|rebuild|switch|update]"
    return 1
    ;;
  esac
}
