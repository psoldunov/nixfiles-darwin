{
  pkgs,
  lib,
  config,
  ...
}: {
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    taps = [
      {name = "koekeishiya/formulae";}
      {name = "felixkratz/formulae";}
    ];
    brews = [
      "deno"
      "handbrake"
      "ollama"
      "mas"
      "yabai"
      "skhd"
      "borders"
    ];
    casks = [
      "1password"
      "1password-cli"
      "arc"
      "asana"
      "balenaetcher"
      "beamer"
      "spotify"
      "beardie"
      "cheatsheet"
      "soundsource"
      "loopback"
      "filebot"
      "raspberry-pi-imager"
      "cleanmymac"
      "cleanshot"
      "cscreen"
      "downie"
      "dropzone"
      "expressvpn"
      "figma"
      "geektool"
      "hazel"
      "klokki"
      "mp3tag"
      "nextcloud"
      "notion"
      "openemu"
      "pixelsnap"
      "plexamp"
      "renamer"
      "libreoffice"
      "permute"
      "rightfont"
      "rive"
      "tempbox"
      "tg-pro"
      "the-unarchiver"
      "transmission-remote-gui"
      "transmit"
      "via"
      "numi"
      "logitune"
      "lunar"
      "firefox"
      "affinity-designer"
      "affinity-photo"
      "affinity-publisher"
    ];
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    masApps = {
      "Final Cut Pro" = 424389933;
      Goodnotes = 1444383602;
      Grocery = 1195676848;
      Keynote = 409183694;
      Tot = 1491071483;
      "Web eID" = 1576665083;
      "Color Picker" = 1545870783;
      "iNet Network Scanner" = 403304796;
      "GarageBand" = 682658836;
      "Keystroke Pro" = 1572206224;
      "Amphetamine" = 937984704;
      Image2icon = 992115977;
      Playgrounds = 1496833156;
      Motion = 434290957;
      "1Password for Safari" = 1569813296;
      Speedtest = 1153157709;
      Numbers = 409203825;
      Xcode = 497799835;
      Vimari = 1480933944;
      Pages = 409201541;
      Infuse = 1136220934;
      Pastebot = 1179623856;
      Velja = 1607635845;
      Flow = 1423210932;
      Compressor = 424390742;
      Parcel = 639968404;
      RunCat = 1429033973;
      "DigiDoc4 Client" = 1370791134;
      Shazam = 897118787;
      "Steam Link" = 1246969117;
    };
  };
}
