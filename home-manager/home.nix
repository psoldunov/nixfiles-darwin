{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./modules
  ];

  programs.home-manager.enable = true;

  age.secrets = {
    SHELL_SECRETS = {
      file = ../secrets/SHELL_SECRETS.age;
    };
  };

  home.stateVersion = "24.05";
}
