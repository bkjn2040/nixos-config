{ ... }:

{
  users.users.jun2040.extraGroups = [
    "audio"
    "jackaudio" # Move to separate Jack configuration ?
    "realtime" # Need or not?
    "wireshark"
  ];
}
