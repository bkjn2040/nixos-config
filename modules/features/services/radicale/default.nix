{ ... }:

{
  services.radicale = {
    enable = true;

    settings = {
      server.hosts = [
        "127.0.0.1:5232"
        "[::1]:5232"
      ];

      auth = {
        type = "htpasswd";
        htpasswd_filename = "/var/lib/radicale/users";
        htpasswd_encryption = "bcrypt";
      };

      storage.filesystem_folder = "/var/lib/radicale/collections";
    };

    rights = {
      root = {
        user = ".+";
        collection = "";
        permissions = "R";
      };

      principal = {
        user = ".+";
        collection = "{user}";
        permissions = "RW";
      };

      calendars = {
        user = ".+";
        collection = "{user}/[^/]+";
        permissions = "rw";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/radicale 0750 radicale radicale - -"
    "f /var/lib/radicale/users 0640 radicale radicale - -"
  ];
}
