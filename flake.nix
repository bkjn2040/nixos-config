{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = ./config;

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixos-hardware, ... }@inputs:
    let
      mkHost = hostName:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/${hostName}/configuration.nix ];
        };
    in
    {
      nixosConfigurations = {
        thinkpad = mkHost "thinkpad";
        workstation = mkHost "workstation";
        satellite = mkHost "satellite";
        rspi4 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";

          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            nixos-hardware.nixosModules.raspberry-pi-4
            ./hosts/rspi4/configuration.nix
          ];
        };
        thinkcentre = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/thinkcentre/configuration.nix ];
        };
        dell-g7 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/dell-g7/configuration.nix ];
        };
      };
    };
}
