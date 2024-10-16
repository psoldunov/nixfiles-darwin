{
  pkgs,
  lib,
  config,
  ...
}: let
  blacklistedApps = [
    "CleanMyMac X"
    "System Settings"
    "Finder"
    "Beardie"
    "1Password"
    "Calculator"
    "Zoom"
    "Plexamp"
    "Raycast"
    "Facetime"
  ];

  handle_display_add = (
    pkgs.writeShellScript "handleDislayAdd" ''
      yabai -m config layout bsp
      killall Rectangle
      borders active_color=0xFFFCFDFC inactive_color=0xFF2D3B53 width=2.5 blacklist="${lib.concatMapStrings (app: app + ",") blacklistedApps}" &
    ''
  );

  handle_display_remove = (
    pkgs.writeShellScript "handleDislayRemove" ''
      yabai -m config layout float
      killall borders
      ${pkgs.rectangle}/Applications/Rectangle.app/Contents/MacOS/Rectangle -f &
    ''
  );

  focus_space = (
    pkgs.writeShellScript "focus_space" ''
      # Pass the desired space number as an argument to the script
      DESIRED_SPACE=$1

      if [ -z "$DESIRED_SPACE" ]; then
        echo "Please provide the desired space number as an argument."
        exit 1
      fi

      # Get the spaces JSON data from yabai
      SPACES_JSON=$(yabai -m query --spaces)

      # Extract the number of existing spaces
      EXISTING_SPACES_COUNT=$(echo "$SPACES_JSON" | jq '. | length')

      # Check if the desired space exists
      if [ "$DESIRED_SPACE" -le "$EXISTING_SPACES_COUNT" ]; then
        # If the desired space exists, focus on it
        yabai -m space --focus "$DESIRED_SPACE"
      else
        # If the desired space doesn't exist, create the missing number of spaces
        for ((i=EXISTING_SPACES_COUNT + 1; i<=DESIRED_SPACE; i++)); do
          yabai -m space --create
        done
        # Focus on the newly created space
        yabai -m space --focus "$DESIRED_SPACE"
      fi
    ''
  );

  move_to_space = (
    pkgs.writeShellScript "move_to_space" ''
      # Pass the desired space number as an argument to the script
      DESIRED_SPACE=$1

      if [ -z "$DESIRED_SPACE" ]; then
        echo "Please provide the desired space number as an argument."
        exit 1
      fi

      # Get the spaces JSON data from yabai
      SPACES_JSON=$(yabai -m query --spaces)

      # Extract the number of existing spaces
      EXISTING_SPACES_COUNT=$(echo "$SPACES_JSON" | jq '. | length')

      # Get the id of the currently focused window
      FOCUSED_WINDOW_ID=$(yabai -m query --windows --window | jq -r '.id')

      # Check if the desired space exists
      if [ "$DESIRED_SPACE" -le "$EXISTING_SPACES_COUNT" ]; then
        # If the desired space exists, move the window to it
        yabai -m window --space "$DESIRED_SPACE"
        yabai -m space --focus "$DESIRED_SPACE"
      else
        # If the desired space doesn't exist, create the missing number of spaces
        for ((i=EXISTING_SPACES_COUNT + 1; i<=DESIRED_SPACE; i++)); do
          yabai -m space --create
        done
        # Move the window to the newly created space
        yabai -m window --space "$DESIRED_SPACE"
        yabai -m space --focus "$DESIRED_SPACE"
      fi
    ''
  );

  extraYabaiConfig = ''
    ${lib.concatMapStrings (app: ''
        yabai -m rule --add app='${app}' manage=off
      '')
      blacklistedApps}
  '';

  combinedYabaiConfig = builtins.readFile ./config/yabairc + "\n" + extraYabaiConfig;
in {
  home.file = {
    "${config.home.homeDirectory}/.config/yabai/yabairc" = {
      text = ''
        ${combinedYabaiConfig}

        yabai -m signal --add event=display_removed action="${handle_display_remove}"
        yabai -m signal --add event=display_added action="${handle_display_add}"

        display_count=$(yabai -m query --displays | jq 'length')

        if [ "$display_count" -eq 1 ]; then
            yabai -m config layout float
        else
            yabai -m config layout bsp
            borders active_color=0xFFFCFDFC inactive_color=0xFF2D3B53 width=2.5 blacklist="${lib.concatMapStrings (app: app + ",") blacklistedApps}" &
        fi
      '';
    };
  };

  home.file = {
    "${config.home.homeDirectory}/.config/skhd/skhdrc" = {
      text = ''
        ctrl + alt - 1 : ${focus_space} 1
        ctrl + alt - 2 : ${focus_space} 2
        ctrl + alt - 3 : ${focus_space} 3
        ctrl + alt - 4 : ${focus_space} 4
        ctrl + alt - 5 : ${focus_space} 5
        ctrl + alt - 6 : ${focus_space} 6
        ctrl + alt - 7 : ${focus_space} 7
        ctrl + alt - 8 : ${focus_space} 8
        ctrl + alt - 9 : ${focus_space} 9
        ctrl + alt - 0 : ${focus_space} 10
        ctrl + alt + shift - 1 : ${move_to_space} 1
        ctrl + alt + shift - 2 : ${move_to_space} 2
        ctrl + alt + shift - 3 : ${move_to_space} 3
        ctrl + alt + shift - 4 : ${move_to_space} 4
        ctrl + alt + shift - 5 : ${move_to_space} 5
        ctrl + alt + shift - 6 : ${move_to_space} 6
        ctrl + alt + shift - 7 : ${move_to_space} 7
        ctrl + alt + shift - 8 : ${move_to_space} 8
        ctrl + alt + shift - 9 : ${move_to_space} 9
        ctrl + alt + shift - 0 : ${move_to_space} 10
        alt - return : ${pkgs.kitty}/bin/kitty --single-instance -d ~
      '';
    };
  };
}
