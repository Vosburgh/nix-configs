{ config, inputs, pkgs, outputs, ... }:
{
  imports = [
    ./../theme
    outputs.homeModules.gtk
    outputs.homeModules.dunst
    # outputs.homeModules.hyprland
    outputs.homeModules.lazygit
    outputs.homeModules.starship
    outputs.homeModules.neovim
    outputs.homeModules.zsh
    outputs.homeModules.godot-mono
  ];

  # Custom Modules
  gtk.config.enable = true;
  # hyprland.enable = true;
  # dunst.enable = true;
  starship.enable = true;
  # neovim.enable = true;
  zsh.enable = true;
  lazygit.enable = true;

  home.sessionVariables = {
    EDITOR = "zed";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    NIXPKGS_ALLOW_UNFREE = "1";
  };

  home = {
    username = "nick";
    homeDirectory = "/home/nick";
    stateVersion = "23.11";
    packages = with pkgs; [

      # Programs
      # beeper
      beyond-all-reason # RTS game
      bitwarden-desktop
      blender
      btop
      # dunst
      element-desktop
      git
      godot
      # grimblast
      htop
      killall
      kitty
      krita
      libreoffice-qt
      lutris
      material-maker

      # nexusmods-app-unfree
      nvtopPackages.amd
      nwg-look
      obs-studio
      obsidian
      pavucontrol
      prismlauncher
      qbittorrent
      r2modman
      rofi
      spotify
      thunderbird
      # trenchbroom
      vesktop
      zed-editor

      # kdePackages
      kdePackages.dolphin
      # Plugins for dolphin
      kdePackages.kdegraphics-thumbnailers
      kdePackages.ffmpegthumbs
      kdePackages.qtimageformats

      # Utilities
      appimage-run # Just for running appimage's
      bat
      delta
      eza
      fzf
      mesa-demos
      ncdu
      neofetch
      nodejs
      p7zip
      polkit_gnome
      wget
      wev # wayland event viewer
      tree
      unzip
      unrar

      # # winetricks (all versions)
      # winetricks

      # # native wayland support (unstable)
      # wineWowPackages.waylandFull
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    rocmSupport = true;
  };
  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = true;

  programs = {
    git = {
      enable = true;
      userName = "Vosburgh";
      userEmail = "nickvosburghy@gmail.com";
    };

    # Cheat sheets
    navi = {
      enable = true;
      enableZshIntegration = true;
    };

    home-manager = {
    	enable = true;
    };

    mpv = {
    	enable = true;
     	scripts = [
      		pkgs.mpvScripts.uosc # Better mpv client
      ];
    };
  };


  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
    easyeffects = {
      enable = true;
    };

  };
}
