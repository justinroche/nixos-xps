{config, ...}: let
  settings = import ./settings.nix;
in {
  programs.plasma = {
    configFile.kdeglobals = {
      Sounds.Theme = "PS5";
      "KFileDialog Settings"."Show hidden files" = true;
    };

    input = {
      touchpads = [
        {
          name = "DELL097D:00 04F3:311C Touchpad";
          vendorId = "04f3";
          productId = "311c";
          naturalScroll = true;
          accelerationProfile = "none";
        }
      ];
    };

    workspace.wallpaperSlideShow = {
      path = ["${config.home.homeDirectory}/${settings.wallpaper.directory}"];
      interval = settings.wallpaper.interval;
    };
  };
}
