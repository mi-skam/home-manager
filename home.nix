{ config, lib, pkgs, ... }:

with builtins;
with lib;
with pkgs;

let
  currentDir = ./.;

  writeCommand = name: stdenv.mkDerivation {
    inherit name;
    src = currentDir;
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp ${./shared/${name}.sh} $out/bin/${name}
      chmod +x $out/bin/${name} 
    '';
  };

  hm = writeCommand "hm"; 
  openPRs = writeCommand "open-prs";
  wr = writeCommand "wr";

  bashHelper = readFile ./shared/bash-helper.sh;
  bashEnv = readFile ./shared/bash-environment.sh;
  npmrc = ./shared/npmrc;
  gitconfig = "${currentDir}/shared/gitconfig";
  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin
    {
      pluginName = "tmux-super-fingers";
      version = "unstable-2023-11-09";
      src = pkgs.fetchFromGitHub {
        owner = "artemave";
        repo = "tmux_super_fingers";
        rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
        sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
      };
    };

in {
  home = {
    stateVersion = "23.05";
    shellAliases = {
      "pn" = "pnpm";
      "b" = "bun";
      "bx" = "bunx";
      "g" = "git";
      "..." = "cd ../..";
      ".." = "cd ..";
      "l" = "ls";
      "ll" = "ls -lah";
      "ls" = lib.getExe pkgs.lsd;
      "t" = "tree";
      "tree" = "${lib.getExe pkgs.lsd} --tree";
      "lg" = "lazygit";
      "e"  = "nvim";
      "cd" = "z";
      "rf" = "rm -rf";
    };
    file = { ".npmrc".source = npmrc; };
    packages = with pkgs; [
      libwebp
      bashInteractive
      universal-ctags
      ffmpeg
      htop
      curl
      wget
      nodejs_18
      tree
      ripgrep
      fd
      cmus
      mtr
      nixfmt
      bat
      exa
      # custom scripts
      hm
      openPRs
      wr
    ];
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = lib.strings.concatLines [ bashEnv bashHelper ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        aliases = {
          co = "pr checkout";
          pv = "pr view";
        };
      };
    };

    git = {
      enable = true;
      diff-so-fancy.enable = true;
      includes = [{ path = gitconfig; }];
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

    lazygit.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        {
          plugin = telescope-nvim;
          config = ''
            let mapleader = ","

            " Find files using Telescope command-line sugar.
            nnoremap <leader>ff <cmd>Telescope find_files<cr>
            nnoremap <leader>fg <cmd>Telescope live_grep<cr>
            nnoremap <leader>fb <cmd>Telescope buffers<cr>
            nnoremap <leader>fh <cmd>Telescope help_tags<cr>
          '';
        }
        telescope-nvim
        plenary-nvim
        nvim-treesitter
        terminus
        {
          plugin = lazygit-nvim;
          config = ''
            let mapleader = ","

            nnoremap <leader>lg <cmd>LazyGit<cr>
          '';
        }
      ];
      extraConfig = ''
        let mapleader = ","
        set shell=$HOME/.nix-profile/bin/bash

        " reload vimconfig
        nnoremap <leader>rr :source $MYVIMRC<CR>


        set number
        set relativenumber

        " map shortcuts to hm
        nnoremap <leader>hb :!hm<space>build<cr>
        nnoremap <leader>hu :!hm<space>update<cr>
        nnoremap <leader>hf :!hm<space>fetch<cr>
      '';
      extraPackages = with pkgs; [ ripgrep fd ];
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
    };
    tmux = {
      enable = true;
      clock24 = true;
      disableConfirmationPrompt = true;
      prefix = "C-a";
      terminal = "screen-256color";
      keyMode = "vi";
      mouse = true;
      newSession = true;
      plugins = with pkgs; [
        tmuxPlugins.cpu
        tmuxPlugins.better-mouse-mode
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = "set -g @ressurect-strategy-nvim 'session'";
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
        {
          plugin = tmux-super-fingers;
          extraConfig = "set -g @super-fingers-key f";
        }

      ];
      extraConfig = ''
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        bind-key -n M-Left select-pane -L
        bind-key -n M-Down select-pane -D
        bind-key -n M-Up select-pane -U
        bind-key -n M-Right select-pane -R
        
        bind-key | split-window -h
        bind-key - split-window -v

        bind-key -n M-s set-window-option synchronize-panes
      '';
    };

    yt-dlp = { enable = true; };

    zoxide.enable = true;
  };

  services = { 
    syncthing = { 
      enable = true;
      extraOptions = [
        "--gui-address=127.0.0.1:8387"
      ];
    }; 
  };
}
