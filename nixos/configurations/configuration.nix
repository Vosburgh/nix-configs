{ inputs, config, lib, pkgs, outputs, ... }:
{

  # Imports
  imports = [
    ./bootloader.nix
    ./hardware-configuration.nix
    outputs.nixosModules.kdeplasma6
    outputs.nixosModules.steam
    outputs.nixosModules.syncthing
    inputs.home-manager.nixosModules.default
  ];

  # Custom Modules
  # hyprland.enable = true;
  kdePlasma6.enable = true;
  steam.enable = true;
  syncthing.enable = true;
  # sunshine.enable = true;

  # Define your hostname.
  networking.hostName = "artorias";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  # Specify kernel to use
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "America/Vancouver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "";
    };

  services.displayManager = {
      sddm = {
        enable = true;
      };
      defaultSession = "plasma";
  };

  nix.settings = {
    # Enable flakes and 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };


  #Polkit
  security.polkit.enable = true;
    systemd = {
    user.services.polkit-kde-authentication-agent-1 = {
      description = "polkit-kde-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        };
      };
  };



  # Configure Hardware
  hardware = {
    bluetooth.enable = true;
    # Borked
    # openrazer.enable = true;
  };

  # Mount NAS
#  fileSystems."/mnt/nasburgh/data" = {
#    device = "192.168.50.137:/volume1/data";
#    fsType = "nfs";
#    options = [
#      "x-systemd.automount"
#      "noauto"
#      "x-systemd.idle-timeout=60"
#      "x-systemd.device-timeout=5s"
#      "x-systemd.mount-timeout=5s"
#    ];
#  };

#  fileSystems."/mnt/nasburgh/personal" = {
#    device = "192.168.50.137:/volume1/Personal";
#    fsType = "nfs";
#    options = [
#      "x-systemd.automount"
#      "noauto"
#      "x-systemd.idle-timeout=60"
#      "x-systemd.device-timeout=5s"
#      "x-systemd.mount-timeout=5s"
#    ];
#  };


  # Enable sound
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    # extraConfig = ''
    #       context.objects = [
    #         {
    #           factory = adapter;
    #           args = {
    #             node.rules = [
    #               {
    #                 matches = [
    #                   {
    #                     "media.class" = "Audio/Source"; # Matches all input devices
    #                   }
    #                 ];
    #                 actions = {
    #                   "update-props" = {
    #                     "audio.processing.disable-agc" = true;
    #                   };
    #                 };
    #               }
    #             ];
    #           };
    #         }
    #       ];
    #     '';

    wireplumber.enable = true;
    wireplumber.extraConfig = {
        "bluez-monitor.properties" = {
          "bluez5.autoswitch-profile" = false;
          "bluez5.enable-hsp" = false;
          "bluez5.enable-hfp" = false;
          "bluez5.roles" = [ "a2dp_sink" "a2dp_source" ];  # Configure roles
        };
      };

          # ["bluez5.enable-sbc-xq"] = true,
          # ["bluez5.enable-msbc"] = true,
          # ["bluez5.enable-hw-volume"] = true,
    # wireplumber.extraConfig.bluetoothEnchancements = { "monitor.bluez.properties" = { "bluez5.autoswitch-profile" = false; }; };
  };

  # User Configure
  users.users.nick = {
    isNormalUser = true;
    description = "Nick Vosburgh";
    extraGroups = [ "networkmanager" "wheel" "openrazer" "plugdev"];
    shell = pkgs.zsh;
  };

  # Garbage collection
#   nix.gc = {
#   # automatic = true;
#   # dates = "daily";
#   # options = "--delete-older-than 7d";
# };


  # Configure environment
  environment = {
    systemPackages = with pkgs; [
      alsa-lib
      brightnessctl
      cifs-utils
      ffmpeg-full
      fuse
      git
      git-lfs
      keyutils
      openrazer-daemon
      polychromatic
      wireguard-tools

      wineWowPackages.waylandFull   # or staging/full
      winetricks
      # freetype
      # fontconfig
      # cabextract
    ];
  };

  environment.sessionVariables = {
    EDITOR = "zed";
    BROWSER = "firefox";
    TERMINAL = "kitty";
  };

  # Configure fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-han-sans
      source-han-serif
      source-han-mono
      source-han-code-jp
      twitter-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      dina-font
      ubuntu-classic
      # nerdfonts
      nerd-fonts.fira-code
      # (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];

    # Enable default fonts
    enableDefaultPackages = true;

    # Configure default fonts
    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu" "Regular" ];
        sansSerif = [ "Ubuntu" "Regular" ];
        monospace = [ "FiraCode Nerd Font" "Regular" ];
      };
    };
  };

  # Allow proprietary software
  nixpkgs.config.allowUnfree = true;

  # Configure system-wide programs
  programs = {
    # Enable firefox
    firefox.enable = true;

    # Needed for anything GTK
    dconf.enable = true;

    zsh.enable = true;

    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];

    xfconf.enable = true;


    # Allows 3rd party shit to work with nix-shell
    nix-ld = {
	    enable = true;
    };
  };

  # Configure system-wide services
  services = {
    blueman.enable = true; # Enable bluetooth support and device management (via bluetooth manager)

    flatpak.enable = true;  # Enable flatpak for non-nix packages (or temporary broken packages)

    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images

    tailscale.enable = true;

    printing.enable = true; # Enable CUPS to print documents
  };

  # Virtualisation enable
  # virtualisation.virtualbox.host.enable = true;

  # Enable portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Allow swaylock to work correctly
  security.pam.services.swaylock = {};

    # Get location from geoclue
    # TODO: Doesn't work
  location.provider = "geoclue2";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
