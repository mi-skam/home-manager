{ config, lib, pkgs, ... }:

with builtins;
with lib;
with pkgs;

let
  currentDir = ./.;

  writeCommand = name:
    stdenv.mkDerivation {
      inherit name;
      src = currentDir;
      phases = [ "installPhase" ];
      installPhase = ''
        mkdir -p $out/bin
        cp ${./shared/${name}.sh} $out/bin/${name}
        chmod +x $out/bin/${name} 
      '';
    };

  bashHelper = readFile ./shared/bash-helper.sh;
  bashEnv = readFile ./shared/bash-environment.sh;
  bashDarwin = readFile ./shared/bash-darwin.sh;

  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin {
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
    file = {
      ".config/git/.gitconfig-github-mi-skam".source =
        ./shared/gitconfig-github-mi-skam;
      ".config/git/.gitconfig-gitlab-nobj".source =
        ./shared/gitconfig-gitlab-nobj;
      ".config/ytcc/ytcc.conf".source = ./shared/ytcc-config;
      ".emacs.d/init.el".source = ./shared/emacs-config.el;
    };
    packages = with pkgs; [
      act
      libwebp
      bashInteractive
      universal-ctags
      ffmpeg
      htop
      curl
      wget
      mpv
      ytcc
      nodejs_20
      tree
      ripgrep
      fd
      cmus
      mtr
      nixfmt
      bat
      eza
      tailscale
      # custom scripts
      (writeCommand "hm")
      (writeCommand "wr")
      (writeCommand "yt-play")
      (writeCommand "open-prs")
      google-cloud-sdk
    ];
    stateVersion = "23.05";
    shellAliases = {
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
      "e" = "nvim";
      "cd" = "z";
      "rf" = "rm -rf";
    };
    username = "plumps";
    homeDirectory = "/dev/null";
  };

  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = lib.strings.concatLines
        (lib.optionals stdenv.isDarwin [ bashDarwin ]
          ++ [ bashEnv bashHelper ]);
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    emacs = { enable = true; };

    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
      settings = {
        # Workaround for https://github.com/nix-community/home-manager/issues/4744
        version = 1;
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
      includes = [{ path = ./shared/gitconfig; }];
      lfs.enable = true;
      userName = "mi-skam";
      userEmail = "codes@miskam.xyz";
      extraConfig = {
        core.editor = "vim";
        pull.rebase = true;
        init.defaultBranch = "main";
      };
    };

    git-credential-oauth.enable = true;

    helix = {
      enable = true;
      settings = {
        keys.normal = {
          space.space = "file_picker";
          s = "move_char_left";
          n = "move_visual_line_down";
          r = "move_visual_line_up";
          t = "move_char_right";
        };
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
            let mapleader = " "

            " Find files using Telescope command-line sugar.
            nnoremap <leader><leader> <cmd>Telescope find_files<cr>
            nnoremap <leader>g <cmd>Telescope live_grep<cr>
            nnoremap <leader>b <cmd>Telescope buffers<cr>
            nnoremap <leader>h <cmd>Telescope help_tags<cr>
          '';
        }
        telescope-nvim
        plenary-nvim
        nvim-treesitter
        terminus
        {
          plugin = lazygit-nvim;
          config = ''
            let mapleader = " "

            nnoremap <leader>lg <cmd>LazyGit<cr>
          '';
        }
      ];
      extraConfig = ''
        let mapleader = " "
        set shell=$HOME/.nix-profile/bin/bash

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
      extraOptions = [ "--gui-address=127.0.0.1:8387" ];
    };
  };
}
