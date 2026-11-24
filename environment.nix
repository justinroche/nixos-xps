rec {
  user = rec {
    name = "justin";
    fullName = "Justin Roche";
    email = "justinroche03@gmail.com";
    homeDirectory = "/home/${name}";
  };

  host = {
    name = "justin-xps";
    system = "x86_64-linux";
  };

  repository = rec {
    name = "nixos-xps";
    directory = "${user.homeDirectory}/${name}";
  };

  locale = {
    timeZone = "America/Chicago";
    defaultLocale = "en_US.UTF-8";
    keyMap = "us";
  };

  paths.sopsAgeKey = "${user.homeDirectory}/.config/sops/age/keys.txt";
}
