{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules
  ];

  programs.home-manager.enable = true;

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/Users/psoldunov/.config/sops/age/keys.txt";

    secrets = {
      SHELL_SECRETS = {};
    };
  };

  home.stateVersion = "24.05";
}
