{ ... }:

let
  keys = import ../keys;
in {
  users.users.jun2040.openssh.authorizedKeys.keyFiles = [
    keys.thinkpad
    keys.workstation
  ];
}
