{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, nixos-hardware, ... }@inputs:
    let
      mkx8664Host = hostName:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/${hostName}/configuration.nix ];
        };
    in
    {
      nixosConfigurations = {
        thinkpad = mkx8664Host "thinkpad";
        workstation = mkx8664Host "workstation";
        satellite = mkx8664Host "satellite";
        thinkcentre = mkx8664Host "thinkcentre";
        dell-g7 = mkx8664Host "dell-g7";

        rspi4 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";

          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            nixos-hardware.nixosModules.raspberry-pi-4
            ./hosts/rspi4/configuration.nix
          ];
        };
      };
    };
}
