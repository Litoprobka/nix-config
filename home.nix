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

  home.keyboard.layout = "km,c2wru";
  home.keyboard.options = ["grp:sclk_toggle"];

  services.syncthing.enable = true;

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
