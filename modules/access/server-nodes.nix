{ ... }:

let
  keys = import ../keys;
in {
  users.users.jun2040.openssh.authorizedKeys.keyFiles = [
    keys.thinkpad
    keys.workstation
  ];

  nix.settings.trusted-users = [
    "root"
    "jun2040"
  ];

  # SSH-key possession effectively controls administrative access.
  security.sudo.wheelNeedsPassword = false;
}
