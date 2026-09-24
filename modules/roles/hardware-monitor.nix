{ pkgs, ... }:

{
  boot.kernelModules = [ "coretemp" ];

  # Proactive Intel thermal management.
  services.thermald.enable = true;

  environment.systemPackages = with pkgs; [
    lm_sensors
    linuxPackages.turbostat
    nvtopPackages.nvidia
    stress-ng
    powertop
  ];
}
