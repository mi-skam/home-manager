{pkgs, ...}: {
  home.username = "plumps";
  home.homeDirectory = "/Users/plumps";
  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    bashInteractive
  ];

  programs = {
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
      extraConfig = ''
        map <leader> ,
      '';
    };

    starship = {
      enable = true;
    };
  };
}
