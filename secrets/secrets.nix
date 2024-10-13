let
  psoldunov = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDIMAhXWVgdNszKi5tHVWcSShMWGmalM+dqwHFVZ8XoU philipp@theswisscheese.com";
  users = [psoldunov];
in {
  "SHELL_SECRETS.age".publicKeys = [psoldunov];
}
