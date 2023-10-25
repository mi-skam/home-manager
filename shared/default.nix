{ config, lib, pkgs, ... }:
let hm = builtins.readFile ./hm.sh;
in {
  home = {
    stateVersion = "23.05";
    sessionPath = [ "$HOME/.local/bin" ];
    sessionVariables = { PATH = "$HOME/.npm-global/bin:$PATH"; };
    shellAliases = {
      "pn" = "pnpm";
      "b" = "bun";
      "bx" = "bunx";
      "g" = "git";
      "..." = "cd ../..";
    };
    file = { ".npmrc".source = ./npmrc; };
    packages = with pkgs; [
      bashInteractive
      ffmpeg
      htop
      curl
      wget
      nodejs_18
      tree
      ripgrep
      fd
      python3
      gh
      cmus
      mtr
      nixfmt
    ];
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = lib.strings.concatLines [ hm ];
    };
    git = {
      enable = true;
      includes = [{ path = "~/.config/home-manager/shared/gitconfig"; }];
      lfs.enable = true;
      userName = "mi-skam";
      userEmail = "codes@miskam.xyz";
      extraConfig = {
        core.editor = "vim";
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        telescope-nvim
        plenary-nvim
        nvim-treesitter
      ];
      extraConfig = ''
        let mapleader = ","

        " Find files using Telescope command-line sugar.
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fg <cmd>Telescope live_grep<cr>
        nnoremap <leader>fb <cmd>Telescope buffers<cr>
        nnoremap <leader>fh <cmd>Telescope help_tags<cr>
      '';
      extraPackages = with pkgs; [ ripgrep fd ];
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
    };

    yt-dlp = { enable = true; };
  };

  services = { syncthing = { enable = true; }; };
}
