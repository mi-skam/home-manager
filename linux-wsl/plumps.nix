{ config, pkgs, ... }: {

  config = {
    home.username = "plumps";
    home.homeDirectory = "/Users/plumps";

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
