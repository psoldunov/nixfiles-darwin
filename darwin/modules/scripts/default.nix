{
  pkgs,
  config,
  ...
}: {
  rebuild_system = (
    pkgs.writeShellScriptBin "rebuild_system" ''
      yabai_config_checksum=$(md5sum "/Users/psoldunov/.config/yabai/yabairc" | awk '{ print $1 }')
      cd /Users/psoldunov/.nixfiles
      git add .
      git commit -am "rebuild commit $(date '+%d/%m/%Y %H:%M:%S')"
      darwin-rebuild switch --show-trace --flake ~/.nixfiles
      if [ "$yabai_config_checksum" != "$(md5sum "/Users/psoldunov/.config/yabai/yabairc" | awk '{ print $1 }')" ]; then
        yabai --restart-service
      fi
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
      yabai_config_checksum=$(md5sum "/Users/psoldunov/.config/yabai/yabairc" | awk '{ print $1 }')
      cd /Users/psoldunov/.nixfiles
      git add .
      git commit -am "pre-update commit $(date '+%d/%m/%Y %H:%M:%S')"
      nix flake update
      darwin-rebuild switch --show-trace --flake /Users/psoldunov/.nixfiles
      if [ "$yabai_config_checksum" != "$(md5sum "/Users/psoldunov/.config/yabai/yabairc" | awk '{ print $1 }')" ]; then
        yabai --restart-service
      fi
      skhd --restart-service
    ''
  );
}
