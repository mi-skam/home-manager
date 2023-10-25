We use a central command - `hm` - to manage all maintenance tasks.

## Installation

Clone this repository to `$HOME/.config/home-manager` and use home-manager to switch to the configuration.

Requirements:
- nix
- home-manager

```
git clone https://github.com/mi-skam/home-manager.git $HOME/.config/home-manager
home-manager switch -b backup --flake ~/.config/home-manager#"plumps@linux"
# or
home-manager switch -b backup --flake ~/.config/home-manager#"plumps@macos"
```

### edit
opens the `home-manager` config folder in `$EDITOR`.

### build
switches to a new configuration.

### fetch
updates the source code and the nix flakes inputs (like nixpkgs)

## update
`fetch` and `build` in one command
