{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [./services/pipewire.nix];
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
    discord
    ouch
    haskellPackages.fourmolu
    ripgrep
    thunderbird
    rnnoise-plugin
    godot-mono
    lua-language-server
  ];
  nix.registry.pkgs.flake = inputs.nixpkgs;
  nix.registry.stable.flake = inputs.nixpkgs-stable;

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
    initContent = ''
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
    general.import = ["~/.config/alacritty/themes/themes/gruvbox_dark.toml"]; # todo: add the theme to nix config

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
  programs.git = {
    enable = true;
    userEmail = "52280455+Litoprobka@users.noreply.github.com";
    userName = "Peter Burtsev";
  };
  programs.gh.enable = true;

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.open-vsx; [
      s-nlf-fh.glassit
      janw4ld.lambda-black
      adam-bender.commit-message-editor
      eamodio.gitlens
    ];
    profiles.default.userSettings = {
      "http.proxySupport" = "on";

      "editor.fontFamily" = "'Fira Code', 'Droid Sans Mono', 'monospace', monospace"; # I'm not sure why monospace is listed twice
      "editor.fontSize" = 16;
      "editor.fontLigatures" = true;
      "editor.semanticHighlighting.enabled" = true;

      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;

      "glassit.alpha" = 255; # 220
      "workbench.colorTheme" = "Lambda Dark+";
      "workbench.activityBar.location" = "hidden";
      "workbench.statusBar.visible" = true;

      "window.menuBarVisibility" = "toggle";
      "window.doubleClickIconToClose" = true;
      "window.titleBarStyle" = "native";
      "window.customTitleBarVisibility" = "never";

      "nix.formatterPath" = "alejandra";
      "nix.enableLanguageServer" = true;

      "explorer.confirmDragAndDrop" = false;
      "explorer.confirmDelete" = false;

      "haskell.sessionLoading" = "multipleComponents";
      "haskell.formattingProvider" = "fourmolu";
      "haskell.plugin.semanticTokens.globalOn" = true;
      "haskell.plugin.semanticTokens.config.typeVariableToken" = "parameter";

      "C_Cpp.formatting" = "clangFormat";
      "C_Cpp.clang_format_fallbackStyle" = "{ BasedOnStyle: Chromium, IndentWidth: 4 }";

	    "chat.commandCenter.enabled" = false;
	    # seems like rg loops indefinitely when vscode tries to reindex the project
	    "search.followSymlinks" = false;
    };
  };

  programs.zed-editor = { 
    enable = true;
    extensions = ["nix" "haskell"];
    userSettings = {
      ui_font_size = 16;
      buffer_font_size = 16;
      buffer_font_family = "Fira Code";
      theme = {
        mode = "system";
        light = "One Light";
        dark = "Gruvbox Dark Hard";
      };
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
    };
  };

  # KDE seems to ignore these?..
  home.keyboard.layout = "km,c2wru";
  home.keyboard.options = ["grp:sclk_toggle"];

  services.syncthing.enable = true;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
