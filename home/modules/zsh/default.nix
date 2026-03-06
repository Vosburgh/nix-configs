{ config, lib, pkgs, ... }:

{
  # Add options for zsh
  options.zsh.enable = lib.mkEnableOption "zsh";

  # Configure zsh if desired
  config = lib.mkIf config.zsh.enable {

    home.file.".config/bat/themes/cyberdream.tmTheme".source = ./bat/cyberdream.tmTheme;
    # Configure zsh
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = ''
      # Bat theme
      export BAT_THEME=cyberdream

      # FZF Previews
      export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'"
      export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
      # Advanced customization of fzf options via _fzf_comprun function
      # - The first argument to the function is the name of the command.
      # - You should make sure to pass the rest of the arguments to fzf.
      _fzf_comprun() {
        local command=$1
        shift
        case "$command" in
          cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
          export|unset) fzf --preview "eval 'echo \''${}'"         "$@" ;;
          ssh)          fzf --preview 'dig {}'                   "$@" ;;
          *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
        esac
      }
      '';
      shellAliases = {
        deploy = "nixos-rebuild switch --flake ~/.config/nix#artorias --sudo";
        deploy-home = "home-manager switch -b backup --flake  ~/.config/nix#nick@artorias --verbose";
        dots = "cd /home/nick/.config/nix";
        update = "nix flake update";
        clean-up = "sudo nix-collect-garbage";
        cat = "bat";
        ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
        unfuck = "sudo nix-store --repair --verify --check-contents";
      };
      history.size = 10000;
      history.path = "${config.xdg.dataHome}/zsh/history";

      oh-my-zsh = {
        enable = true;
        plugins = [
          # "thefuck"
          "git"
          "fzf"
          ];
      };
    };

    home.packages = with pkgs; [
      # thefuck # Borked
      fzf
      dig
    ];
  };
}
