{
  self,
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  scripts = import ./modules/scripts {
    pkgs = pkgs;
    config = config;
  };
in {
  imports = [
    ./modules
  ];

  nix = {
    package = pkgs.nixVersions.git;
    settings = {
      experimental-features = "nix-command flakes";
    };
  };

  nix-homebrew = {
    enable = true;
    enableRosetta = true;
    user = "psoldunov";
    autoMigrate = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  services.nix-daemon.enable = true;

  environment.systemPackages =
    (with pkgs; [
      alt-tab-macos
      appcleaner
      bartender
      cyberduck
      iina
      btop
      cocoapods
      boost
      cmatrix
      docker
      docker-compose
      docker-ls
      eza
      ffmpeg
      sops
      flac
      fzf
      git
      htop
      gh
      imagemagick
      iperf
      jq
      libheif
      lsd
      mkvtoolnix
      syncthing
      tldr
      webp-pixbuf-loader
      woff2
      yazi
      localsend
      obsidian
      discord
      kitty
      postman
      raycast
      rectangle
      slack
      telegram-desktop
      mkalias
      zed
      zoom-us
      fastfetch
      alejandra
      neovim
      home-manager
      vscode
    ])
    ++ (with scripts; [
      update_system
      rebuild_system
      clean_system
    ]);

  fonts.packages = [
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  nixpkgs.config.allowUnfree = true;

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
      # Set up applications.
      echo "setting up /Applications..." >&2
      rm -rf /Applications/Nix\ Apps
      find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
      while read src; do
        app_name=$(basename "$src")
        echo "copying $src" >&2
        ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/$app_name"
      done
    '';

  users.users.psoldunov = {
    name = "psoldunov";
    home = "/Users/psoldunov";
    shell = pkgs.fish;
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  programs = {
    fish.enable = true;
    zsh.enable = true;
  };

  security.pam.enableSudoTouchIdAuth = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
