{ pkgs, ... }:

let
  nextAuthSecret = "/var/lib/linkwarden/nextauth-secret";
in
{
  services.linkwarden = {
    enable = true;
    enableRegistration = true;
    host = "0.0.0.0";

    secretFiles.NEXTAUTH_SECRET = nextAuthSecret;

    environment.NEXTAUTH_URL = "http://thinkcentre:3000/api/v1/auth";
  };

  # Linkwarden requires a stable secret for signing sessions. Generate it on
  # the first start and keep it alongside the service's persistent state.
  systemd.services.linkwarden.serviceConfig = {
    UMask = "0077";
    ExecStartPre = pkgs.writeShellScript "linkwarden-nextauth-secret" ''
      if [[ ! -s ${nextAuthSecret} ]]; then
        ${pkgs.coreutils}/bin/head -c 48 /dev/urandom \
          | ${pkgs.coreutils}/bin/base64 > ${nextAuthSecret}
      fi
    '';
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3000 ];
}
