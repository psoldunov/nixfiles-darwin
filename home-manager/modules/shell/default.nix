{
  config,
  pkgs,
  ...
}: {
  home.sessionVariables = {
    GOPATH = "/home/psoldunov/.go";
    MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
    TERMINAL = "kitty";
    TERM = "xterm-256color";
    EDITOR = "nano";
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      reload = "source ~/.config/fish/config.fish && echo 'FISH config reloaded.'";
    };

    plugins = [
      {
        name = "nvm.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "nvm.fish";
          rev = "a0892d0bb2304162d5faff561f030bb418cac34d";
          sha256 = "GTEkCm+OtxMS3zJI5gnFvvObkrpepq1349/LcEPQRDo=";
        };
      }
    ];
    functions = {
      mkcd = {
        body = ''mkdir -p "$argv" && cd "$argv"'';
      };
      fzf_kill = {
        body = ''kill $(ps aux | ${pkgs.fzf}/bin/fzf | awk '{print $2}')'';
      };
    };
    shellInit = ''
      set -Ua fish_user_paths $HOME/.cargo/bin:/Users/psoldunov/.nix-profile/bin:/etc/profiles/per-user/psoldunov/bin:/run/current-system/sw/bin:/opt/homebrew/bin
      set --export BUN_INSTALL "$HOME/.bun"
      set --export PATH $BUN_INSTALL/bin $PATH
      set fish_greeting
      if test -d (brew --prefix)"/share/fish/completions"
          set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
      end

      if test -d (brew --prefix)"/share/fish/vendor_completions.d"
          set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
      end
    '';
    # shellInitLast = "source ${config.sops.secrets.SHELL_SECRETS.path}";
  };

  home.shellAliases = {
    ls = "${pkgs.lsd}/bin/lsd -laFh";
    rm = "${pkgs.glib}/bin/gio trash";
    fucking = "sudo";
    cat = "${pkgs.bat}/bin/bat";
    ssh = "${pkgs.kitty}/bin/kitten ssh";
  };

  programs.bash = {
    enable = true;
    enableVteIntegration = true;
    enableCompletion = true;
    # bashrcExtra = "source ${config.sops.secrets.SHELL_SECRETS.path}";
  };

  programs.zsh = {
    enable = true;
    enableVteIntegration = true;
    enableCompletion = true;
    # initExtra = "source ${config.sops.secrets.SHELL_SECRETS.path}";
  };

  programs.thefuck = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings = {
      format = "$env_var $all";
      hostname = {
        ssh_only = true;
        disabled = false;
      };
      bun = {
        format = "via [🥟 $version](bold green) ";
      };
      nodejs = {
        detect_files = ["package.json" ".node-version" "!bunfig.toml" "!bun.lockb" "!deno.json"];
      };
      deno = {
        format = "via [🦕 $version](green bold) ";
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    options = [
      "--cmd j"
    ];
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
  };
}
