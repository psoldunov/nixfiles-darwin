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
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

    secrets = {
      SHELL_SECRETS = {};
    };
  };

  home.packages = with pkgs; [
    sops
    lolcat
    cowsay
  ];

  home.stateVersion = "24.05";
}
