{ config, pkgs, lib, ... }: {

  config = { home.homeDirectory = lib.mkForce "/Users/plumps"; };
}
