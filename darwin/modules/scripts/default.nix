{
  pkgs,
  config,
  ...
}: {
  rebuild_system = (
    pkgs.writeShellScriptBin "rebuild_system" ''
      cd /Users/psoldunov/.nixfiles
      git add .
      git commit -am "rebuild commit $(date '+%d/%m/%Y %H:%M:%S')"
      darwin-rebuild switch --show-trace --flake ~/.nixfiles
      yabai --restart-service
      skhd --restart-service
    ''
  );

  clean_system = (
    pkgs.writeShellScriptBin "clean_system" ''
      sudo nix-collect-garbage -d
      nix-collect-garbage -d
    ''
  );

  update_system = (
    pkgs.writeShellScriptBin "update_system" ''
      cd /Users/psoldunov/.nixfiles
      git add .
      git commit -am "pre-update commit $(date '+%d/%m/%Y %H:%M:%S')"
      nix flake update
      darwin-rebuild switch --show-trace --flake /Users/psoldunov/.nixfiles
      yabai --restart-service
      skhd --restart-service
    ''
  );
}
