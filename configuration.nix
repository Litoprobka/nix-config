# this part of the configuration is shared between different NixOS installs
# hardware-configuration.nix should be imported by per-system config
{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.extraLayouts.c2wru = {
    description = "Russian (C2W2-phonetic)";
    languages = ["rus"];
    # yes, hardcoding like this is bad
    # UPD: actually, I'm not sure. The nixos config is one interconnected thing, so the file
    # is more or less guaranteed to exist there
    symbolsFile = ./symbols/c2wru; 
  };
  services.xserver.xkb.extraLayouts.km = {
    description = "English (KMonad-complement)";
    languages = ["eng"];
    symbolsFile = ./symbols/km; # ikik
  };

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # services.displayManager.cosmic-greeter.enable = true;
  # services.desktopManager.cosmic.enable = true;

  services.zfs.autoSnapshot.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";
  #
  # for whatever reason, this doesn't seem to work, so I set the layout in home.nix instead

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  users.users.litoprobka = {
    isNormalUser = true;
    extraGroups = ["wheel" "input" "uintput"];
    packages = [];
  };
  users.defaultUserShell = pkgs.zsh;

  security.sudo.wheelNeedsPassword = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.trusted-users = ["root" "litoprobka"];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    micro
    wget
    curl
    alacritty
    firefox
    tldr
    obsidian
    gimp
  ];
  fonts.packages = with pkgs; [
    fira-code
  ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    konsole
    elisa
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.starship = {
    enable = true;
    settings.add_newline = true;
  };

  programs.zsh.enable = true;

  environment.variables.EDITOR = "micro";
  environment.sessionVariables = {
    LC_ALL = "en_US.UTF-8"; # a temporary fix for alacritty
    # XDG dirs
    XDG_CACHE_HOME = "/var/cache/litoprobka"; # I have a different sub-pool for cache files that is mounted on /var/cache; used to be "$HOME/.local/cache"
    XDG_CONFIG_HOME = "$HOME/.config"; # todo: move it to a non-dot folder, either ~/config or ~/local/config
    XDG_DATA_HOME = "$HOME/local/data";
    XDG_STATE_HOME = "$HOME/local/state";
    XDG_BIN_HOME = "$HOME/local/apps"; # not supported by the XDG specification yet
    XDG_LIB_HOME = "$HOME/local/lib"; # again, not in XDG specification yet, but I wanna be future-proof

    # brute-forcing XDG compliance
    # this may or may not be a good idea in NixOS
    PYTHONSTARTUP = "$XDG_CONFIG_HOME/pythonrc";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    RUSTFLAGS = "-L $RUSTUP_HOME/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/x86_64-unknown-linux-gnu/lib";
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    STARSHIP_CACHE = "$XDG_CACHE_HOME/starship";
    JULIA_DEPOT_PATH = "$XDG_DATA_HOME/julia:$JULIA_DEPOT_PATH"; # weird
    WINEPREFIX = "$XDG_DATA_HOME/wineprefixes/default";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java";
    GHCUP_USE_XDG_DIRS = "true";
    STACK_XDG = "1";
    KDEHOME = "$XDG_CONFIG_HOME/kde";
    XINITRC = "$XDG_CONFIG_HOME/xinitrc";
    npm_config_userconfig = "$XDG_CONFIG_HOME/npm/config";
    npm_config_cache = "$XDG_CACHE_HOME/npm";
    npm_config_prefix = "$XDG_DATA_HOME/npm";
    PACK_DIR = "$XDG_DATA_HOME/pack";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.automatic-timezoned.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}
