{ config, pkgs, lib, ... }: {

  config = {
    home.homeDirectory = lib.mkForce "/home/plumps";
    home.file = { ".config/lazygit/config.yml".source = ./lazygit.yml; };

    programs.neovim.extraConfig = ''
      " Use win32yank as clipboard provider
      set clipboard+=unnamedplus
      let g:clipboard = {
        \   'name': 'win32yank-wsl',
        \   'copy': {
        \      '+': 'win32yank.exe -i --crlf',
        \      '*': 'win32yank.exe -i --crlf',
        \    },
        \   'paste': {
        \      '+': 'win32yank.exe -o --lf',
        \      '*': 'win32yank.exe -o --lf',
        \   },
        \   'cache_enabled': 1,
        \ }
    '';

  };
}
