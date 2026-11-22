let
  settings = import ./settings.nix;
  kickoffFavorites = builtins.concatStringsSep "," settings.panel.favorites;
in {
  programs.plasma = {
    panels = [
      {
        location = "bottom";
        widgets = [
          {kickoff = {};}
          "org.kde.plasma.pager"
          {
            iconTasks.launchers = settings.panel.launchers;
          }
          {
            plasmaPanelColorizer = {
              general = {
                enable = true;
                hideWidget = true;
              };
              settings.General.globalSettings = builtins.toJSON {
                panel.normal = {
                  enabled = true;
                  backgroundColor = {
                    enabled = true;
                    custom = settings.panel.color;
                    sourceType = 0;
                    alpha = 1.0;
                  };
                };
                nativePanel.background = {
                  enabled = false;
                  shadow = false;
                };
              };
            };
          }
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];

    # Plasma stores Kickoff favorites by the generated widget ID. Set the
    # per-widget global entry after the panel has been created, so the list
    # stays declarative without hard-coding that transient ID.
    startup.desktopScript.kickoff-favorites = {
      priority = 3;
      runAlways = true;
      text = ''
        const favorites = ${builtins.toJSON kickoffFavorites};

        panels().forEach((panel) => {
          panel.widgets()
            .filter((widget) => widget.pluginName === "org.kde.plasma.kickoff")
            .forEach((widget) => {
              const group =
                `Favorites-org.kde.plasma.kickoff.favorites.instance-''${widget.id}-global`;
              const config = ConfigFile("kactivitymanagerd-statsrc", group);
              config.writeEntry("ordering", favorites);
            });
        });
      '';
    };
  };
}
