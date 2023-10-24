We use a central command - `hm` - to manage all maintenance tasks.

## Installation

Requirements:
- nix
- home-manager

clone this repository to $HOME/.config/home-manager and call `home-manager switch -b backup --flake ~/.config/home-manager#"plumps@$option"` whereas
option is either `linux` or `macos`.

### edit
opens the `home-manager` config folder in `$EDITOR`.

### switch
rebuilds the configuration and activates it.

### update
updates the source code and the nix flakes inputs (like nixpkgs)

## Usage
hm [switch|edit|update]
