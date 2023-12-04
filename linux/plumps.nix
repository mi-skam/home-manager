{ config, pkgs, lib, ... }: {
  config = { home.homeDirectory = lib.mkForce "/home/plumps"; };
}
