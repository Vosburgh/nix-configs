{ config, lib, pkgs, ... }:

{
  # Add options for Gtk, toolkit for gnome
  options.gtk.config.enable = lib.mkEnableOption "gtk.config";

  # Configure Gtk if desired
  config = lib.mkIf config.gtk.config.enable {

  gtk = {
    enable = true;
    font = {
      name = "Fira Code 9";
    };
    cursorTheme = {
      name = "phinger-cursors";
      package = pkgs.phinger-cursors;
    };
    iconTheme = {
      name = "Pop";
      package = pkgs.pop-icon-theme;
    };
    theme = {
      package = pkgs.catppuccin-gtk.override {
          accents = ["sapphire"];
          size = "compact";
          tweaks = ["rimless"];
          variant = "macchiato";
        };
      name = "Catppuccin-Macchiato-Compact-Sapphire-Dark";
    };
    gtk2 = {
    	enable = false;
    };
    gtk3 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
    gtk4 = {
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
      };
    };
    # Set environment variables
    };
    home.sessionVariables = {
      GDK_BACKEND = "wayland";
      };
  };
}
