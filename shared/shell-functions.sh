hm() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: hm [switch|edit]"
    return 1
  fi

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

  case "$1" in
  "switch")

    home-manager switch --flake ~/.config/home-manager#"plumps@$option"
    ;;
  "edit")
    echo "TODO: edit mode"
    ;;
  *)
    echo "Usage: hm [switch|edit]"
    return 1
    ;;
  esac
}
