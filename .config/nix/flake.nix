{
  description = "Andrii nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          pkgs.vim
          pkgs.tmux
          pkgs.neovim
          pkgs.python311Packages.exrex    # regex operations
          pkgs.yazi                       # terminal file manager
          pkgs.htop-vim                   # control running processes
          pkgs.eza                        # better `ls`
          pkgs.fzf                        # fuzzy finder
          pkgs.ripgrep                    # better `grep`
          pkgs.fd                         # better `find`
          pkgs.sd                         # better `sed`
          pkgs.git
          pkgs.lazygit                    # TUI for git actions
          pkgs.stylua                     # lua formatter
          pkgs.zk
          # pkgs.dotnetCorePackages.sdk_9_0_1xx
        ];


      system.defaults = {
        dock.autohide = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Andys-MacBook-Air
    darwinConfigurations."Andys-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
