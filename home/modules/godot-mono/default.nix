{ config, lib, pkgs, ... }:

{
  options.godot-mono.enable = lib.mkEnableOption "godot-mono";

  # Configure neovim if desired
  config = lib.mkIf config.godot-mono.enable {

  programs.vscode = {
	enable = true;
	package = pkgs.vscode; # `pkgs.vscodium` is unsupported by "C# Dev Kit" VSCode extension.
	profiles.default = {
		userSettings = {
			"dotnetAcquisitionExtension.existingDotnetPath" = [
				{
					"extensionId" = "ms-dotnettools.csharp";
					"path" = "${pkgs.dotnet-sdk_9}/bin";
				}
				{
					"extensionId" = "ms-dotnettools.csdevkit";
					"path" = "${pkgs.dotnet-sdk_9}/bin";
				}
				{
					"extensionId" = "woberg.godot-dotnet-tools";
					"path" = "${pkgs.dotnet-sdk_8}/bin"; # Godot-Mono uses DotNet8 version.
				}
			];
			"godotTools.lsp.serverPort" = 6005; # port should match your Godot configuration
		};
		extensions = with pkgs.vscode-extensions; [
			geequlim.godot-tools # For Godot GDScript support
			woberg.godot-dotnet-tools # For Godot C# support
			ms-dotnettools.csdevkit
			ms-dotnettools.csharp
			ms-dotnettools.vscode-dotnet-runtime
		] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
			{ name = "godot-files";
				publisher = "alfish";
				version = "0.1.6";
				sha256 = "sha256-FFtl1QXSa4nGKFUJh5f3R7AV7hZg59Qs5vBZHgSUCUw=";
			}
		];
	};
  };

  home.packages = [
	dotnetCorePackages.dotnet_9.sdk # For Godot-Mono VSCode-Extension CSharp
  ];

  };
}
