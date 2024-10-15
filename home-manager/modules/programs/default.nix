{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./kitty.nix
    ./zed.nix
  ];
}
