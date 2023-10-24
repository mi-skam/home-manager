_get_os() {
  os=$(uname -o)
  case "$os" in
  "GNU/Linux")
    option="linux";
    ;;
  "Darwin")
    option="macos";
    ;;
  *)
    echo "Unknown OS: $os"
    exit 1
    ;;
  esac
}

_handle_update() {
    dir="$HOME/.config/home-manager"
    echo "Updating in directory: $dir"
    
    # Change to the specified directory
    pushd "$dir" || { echo "Failed to change to directory: $dir"; return 1; }

    # Perform git pull
    git pull || { echo "Failed to execute git pull"; return 1; }

    # Perform nix flake
    nix flake update || { echo "Failed to execute nix flake"; return 1; }
    
    popd
}

hm() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: hm [switch|edit|update]"
    return 1
  fi

  _get_os

  case "$1" in
  "switch")

    home-manager switch -b backup --flake ~/.config/home-manager#"plumps@$option"
    ;;
  "edit")
    eval $EDITOR $HOME/.config/home-manager
    ;;
  "update")
    _handle_update
    ;;
  *)
    echo "Usage: hm [switch|edit|update]"
    return 1
    ;;
  esac
}
