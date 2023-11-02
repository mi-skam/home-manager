dir="$HOME/.config/home-manager"

# source settings if they exist
if [ -f "$dir/.settings.sh" ]; then
  . "$dir/.settings.sh"
fi

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

_is_wsl() {
  grep -qE "(Microsoft|WSL)" /proc/version &>/dev/null
}

_handle_fetch() {
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

_handle_build() {
  option=$(_get_os)
  home-manager switch -b backup --flake ~/.config/home-manager#"plumps@$option" || {
    echo "Failed to execute nixos-rebuild switch"
    return 1
  }
}

if [ "$#" -ne 1 ]; then
  cat "$dir/README.md"
  exit 1
fi

case "$1" in
"build")
  _handle_build
  ;;
"edit")
  _handle_edit
  ;;
"fetch")
  _handle_fetch
  ;;
"update")
  _handle_fetch
  _handle_build
  ;;
*)
  echo "Usage: hm [fetch|edit|build|update]"
  exit 1
  ;;
esac
