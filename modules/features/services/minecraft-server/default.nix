{ inputs, pkgs, ... }:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  users.users.jun2040.extraGroups = [ "minecraft" ];

  services.minecraft-servers = {
    enable = true;
    # Required to run the server: https://www.minecraft.net/eula
    eula = true;
    openFirewall = true;

    servers.paper = {
      enable = true;
      package = pkgs.paperServers.paper-26_3;
      jvmOpts = "-Xms2G -Xmx4G";

      serverProperties = {
        server-port = 25565;
        gamemode = "survival";
        difficulty = "hard";
        max-players = 20;
        motd = "2026 AAA Server";
        online-mode = true;
        white-list = false;
      };
    };
  };
}
