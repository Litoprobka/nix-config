{
  config,
  pkgs,
  ...
}: {
  home.username = "litoprobka";
  home.homeDirectory = "/home/litoprobka";
  home.packages = with pkgs; [
    neofetch
    telegram-desktop
    home-manager
    lsd
    vscode
    nil
    alejandra
    direnv
    nix-direnv
    cabal2nix
    htop
    cloc
    flameshot
    gh
    sops
    wireguard-tools
    clickhouse
    httm
    prismlauncher
    ghc
    cabal-install
    stack
    haskell-language-server
  ];

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character.success_symbol = "[₽](bold green)";
      character.error_symbol = "[¥](bold red)";
    };
  };

  programs.zoxide.enable = true;

  programs.zsh = {
    enable = true;

    enableCompletion = true;
    completionInit = ''
      autoload -U compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # zsh keybindings
    initExtra = ''
      bindkey ";5D"   backward-word # Ctrl-left
      bindkey ";5C"	  forward-word # Ctrl-right
      bindkey  "^[[H" beginning-of-line # Home
      bindkey  "^[[F" end-of-line # End

      bindkey "^H"    backward-kill-word
    '';

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch";
      s = "sudo";
      please = "sudo";
      cd = "z";
      ls = "lsd";
      ungzip = "gzip -dk";
    };
    dotDir = ".config/zsh-nix";
    history = {
      ignoreAllDups = true;
      path = "${config.xdg.cacheHome}/zsh/history";
    };
  };

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    import = ["~/.config/alacritty/themes/themes/gruvbox_dark.toml"]; # todo: add the theme to nix config

    cursor.style.shape = "Beam";

    font.size = 15.0;
    font.bold = {
      family = "Fira Code";
      style = "Bold";
    };
    font.normal = {
      family = "Fira Code";
      style = "Retina";
    };

    keyboard.bindings = [
      {
        chars = "\\b";
        key = "Back";
        mode = "~Alt";
        mods = "Control";
      }
    ];

    window.opacity = 0.85;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.open-vsx; [
      s-nlf-fh.glassit
      janw4ld.lambda-black
      adam-bender.commit-message-editor
      eamodio.gitlens
    ];
    userSettings = {
      "http.proxySupport" = "on";

      "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', 'monospace', monospace"; # I'm not sure why monospace is listed twice
      "editor.fontSize" = 16;
      "editor.fontLigatures" = true;

      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;

      "glassit.alpha" = 220;
      "workbench.colorTheme" = "Lambda Dark+";
      "workbench.activityBar.location" = "hidden";
      "workbench.statusBar.visible" = true;

      "window.menuBarVisibility" = "toggle";
      "window.doubleClickIconToClose" = true;

      "nix.formatterPath" = "alejandra";
      "nix.enableLanguageServer" = true;

      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;

      "haskell.sessionLoading" = "multipleComponents";
      "haskell.formattingProvider" = "fourmolu";
    };
  };

  # KDE seems to ignore these?..
  home.keyboard.layout = "km,c2wru";
  home.keyboard.options = ["grp:sclk_toggle"];

  services.syncthing.enable = true;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
