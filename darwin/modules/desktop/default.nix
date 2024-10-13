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
  ];

  blacklistBorders =
    blacklistedApps
    ++ [
      # "kitty"
    ];

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
in {
  services.yabai = {
    enable = false;
    config = {
      layout = "bsp";
      focus_follows_mouse = "autofocus";
      window_shadow = "off";
      top_padding = 8;
      bottom_padding = 8;
      left_padding = 8;
      right_padding = 8;
      window_gap = 8;
      external_bar = "all:38:0";
    };
    extraConfig = ''
      ${lib.concatMapStrings (app: ''
          yabai -m rule --add app='${app}' manage=off
        '')
        blacklistedApps}
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa
    '';
  };

  services.skhd = {
    enable = false;
    # skhdConfig = ''
    #   fn - 1 : ${focus_space} 1
    #   fn - 2 : ${focus_space} 2
    #   fn - 3 : ${focus_space} 3
    #   fn - 4 : ${focus_space} 4
    #   fn - 5 : ${focus_space} 5
    #   fn - 6 : ${focus_space} 6
    #   fn - 7 : ${focus_space} 7
    #   fn - 8 : ${focus_space} 8
    #   fn - 9 : ${focus_space} 9
    #   fn - 0 : ${focus_space} 10
    #   fn + shift - 1 : ${move_to_space} 1
    #   fn + shift - 2 : ${move_to_space} 2
    #   fn + shift - 3 : ${move_to_space} 3
    #   fn + shift - 4 : ${move_to_space} 4
    #   fn + shift - 5 : ${move_to_space} 5
    #   fn + shift - 6 : ${move_to_space} 6
    #   fn + shift - 7 : ${move_to_space} 7
    #   fn + shift - 8 : ${move_to_space} 8
    #   fn + shift - 9 : ${move_to_space} 9
    #   fn + shift - 0 : ${move_to_space} 10
    #   alt - return : /Applications/kitty.app/Contents/MacOS/kitty --single-instance -d ~
    # '';
    skhdConfig = ''
      alt - return : /Applications/kitty.app/Contents/MacOS/kitty --single-instance -d ~
    '';
  };

  services.jankyborders = {
    enable = false;
    hidpi = true;
    width = 2.5;
    active_color = "0xFFFCFDFC";
    inactive_color = "0xFF2D3B53";
    blacklist = blacklistBorders;
  };
}
