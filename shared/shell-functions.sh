hm() {
  if [ "$#" -ne 1 ]; then
    echo "Usage: hm <platform>"
    return 1
  fi

  case "$1" in
  "linux")
    home-manager switch --flake ~/.config/home-manager#"plumps@linux"
    ;;
  "macos")
    home-manager switch --flake ~/.config/home-manager#"plumps@macos"
    ;;
  *)
    echo "Unknown platform: $1"
    return 1
    ;;
  esac
}
