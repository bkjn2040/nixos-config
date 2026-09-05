{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixCats.url = ./config;
  };

  outputs =
    { nixpkgs, ... }@inputs:
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
      };
    };
}
