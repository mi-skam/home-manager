{pkgs, ...}: {
  home.username = "plumps";
  home.homeDirectory = "/Users/plumps";
  home.stateVersion = "23.05";

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.shellAliases = {
    "pn" = "pnpm";
    "b" = "bun";
    "bx" = "bunx";
    "g" = "git";
    "..." = "cd ../..";
  };

  home.packages = with pkgs; [
    bashInteractive
    ffmpeg
    htop
    mediainfo
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
  ];

  programs = {
    adb.enable = true;

    bash = {
      enable = true;
      enableCompletion = true;
    };

    git = {
      enable = true;
      includes = [{ path = "~/.config/home-manager/gitconfig"; }];
      lfs.enable = true;
      userName = "mi-skam";
      userEmail = "codes@miskam.xyz";
      extraConfig = {
        core.editor = "vim";
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home-manager.enable = true;

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
      extraPackages = with pkgs; [
        ripgrep
        fd
      ];
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
    };

    yt-dlp = {
      enable = true;
    };
  };

  services = {
    syncthing = {
      enable = true;
    };
  };
}
