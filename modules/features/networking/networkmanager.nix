{ ... }:

{
  networking.networkmanager.enable = true;

  users.users.jun2040.extraGroups = [
    "networkmanager"
  ];
}
