{
  pkgs,
  pkgsUnstable,
  lib,
  environment,
  ...
}: {
  imports = [
    ./plasma
  ];

  home.stateVersion = "26.05"; # never change
  home.username = environment.user.name;
  home.homeDirectory = environment.user.homeDirectory;

  home.packages = with pkgs; [
    alejandra
    codex
    curl
    pkgsUnstable.devenv
    glow
    kdePackages.kzones
    kdePackages.krdc
    lazygit
    nerd-fonts.jetbrains-mono
    plexamp
    prettier
    cargo
    rustc
    rustfmt
    rsync
    tree
    unzip
    vscode
    wget
    wl-clipboard
    xclip
    (writeShellScriptBin "tdev" (builtins.readFile ./tmux/default-session.sh))
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_CONFIG_DIR = environment.repository.directory;
  };

  home.file.".local/share/sounds/PS5" = {
    source = pkgs.fetchFromGitHub {
      owner = "DAK404";
      repo = "PS5-Plasma-Soundtheme";
      rev = "a83644caf74b5212dbcf536366a1cca4058e5f00";
      hash = "sha256-blPkwN5CZD/1dnc3BD1o/tMAg1p1jlwUJ8HinZVpDng=";
    };
    recursive = true;
  };

  programs = {
    bash.enable = true;

    fd = {
      enable = true;
      hidden = true;
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = environment.user.fullName;
          email = environment.user.email;
        };
        core.editor = "nvim";
      };
    };

    kitty = {
      enable = true;
      themeFile = "tokyo_night_night";
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12;
      };
      settings = {
        cursor_shape = "beam";
        disable_ligatures = "always";
      };
    };

    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      imports = [./nvim];
    };

    ripgrep = {
      enable = true;
      arguments = [
        "--max-columns=200"
        "--max-columns-preview"
        "--smart-case"
      ];
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings.tc = {
        HostName = "192.168.1.159";
        User = environment.user.name;
      };
    };

    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      presets = ["pure-preset"];
    };

    tmux = {
      enable = true;
      terminal = "tmux-256color";
      keyMode = "vi";
      prefix = "C-Space";
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        yank
        {
          plugin = tokyo-night-tmux;
          extraConfig = builtins.readFile ./tmux/tokyo-night.conf;
        }
      ];
      extraConfig = lib.concatStringsSep "\n" [
        (builtins.readFile ./tmux/settings.conf)
        (builtins.readFile ./tmux/keybindings.conf)
      ];
    };

    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        rsc = "rsync -a --no-owner --no-group";
        rebuild = "sudo nixos-rebuild switch --flake $NIXOS_CONFIG_DIR#${environment.host.name}";
      };

      initContent = lib.concatStringsSep "\n" [
        (builtins.readFile ./zsh/tmux-autostart.zsh)
        (builtins.readFile ./zsh/transient-prompt.zsh)
        (builtins.readFile ./zsh/devenv-hook.zsh)
      ];
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "natural";
          sort_dir_first = true;
        };
      };
    };
  };
}
