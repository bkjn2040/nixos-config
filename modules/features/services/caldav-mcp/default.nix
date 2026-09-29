{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  secretFile = "/var/lib/caldav-mcp/secrets.env";

  credentialsReady = pkgs.writeShellScript "caldav-mcp-credentials-ready" ''
    if [ -z "''${CALDAV_PASSWORD:-}" ] || [ -z "''${CALDAV_MCP_API_KEY:-}" ]; then
      echo "caldav-mcp requires CALDAV_PASSWORD and CALDAV_MCP_API_KEY in ${secretFile}" >&2
      exit 1
    fi
  '';

  package = pkgs.python3Packages.buildPythonApplication {
    pname = "caldav-mcp";
    version = "0.1.1-unstable-2026-09-11";
    pyproject = true;

    src = inputs.caldav-mcp;

    build-system = [ pkgs.python3Packages.hatchling ];

    dependencies = with pkgs.python3Packages; [
      caldav
      fastmcp
      icalendar
      requests
    ];

    # Upstream pins 3.4.7; nixpkgs currently has a compatible 3.3.1.
    pythonRelaxDeps = [ "fastmcp" ];

    postPatch = ''
      substituteInPlace server.py \
        --replace-fail '"host": "0.0.0.0"' '"host": "127.0.0.1"'
    '';

    pythonImportsCheck = [ "caldav_mcp" ];

    meta = {
      description = "MCP server for CalDAV calendar integration";
      homepage = "https://github.com/gelse/caldav-mcp";
      license = lib.licenses.mit;
      mainProgram = "caldav-mcp";
    };
  };
in
{
  users = {
    users.caldav-mcp = {
      isSystemUser = true;
      group = "caldav-mcp";
    };
    groups.caldav-mcp = { };
  };

  environment.etc."caldav-mcp/secrets.env.example".text = ''
    CALDAV_PASSWORD=replace-with-radicale-password
    CALDAV_MCP_API_KEY=replace-with-a-random-token
  '';

  systemd = {
    tmpfiles.rules = [
      "d /var/lib/caldav-mcp 0750 caldav-mcp caldav-mcp - -"
    ];

    services.caldav-mcp = {
      description = "CalDAV MCP server";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network-online.target"
        "tailscaled.service"
      ];
      after = [
        "network-online.target"
        "tailscaled.service"
      ];

      environment = {
        CALDAV_URL = "http://thinkcentre:5232/jun2040/";
        CALDAV_USERNAME = "jun2040";
        CALDAV_MCP_PORT = "8600";
        CALDAV_MCP_PATH = "/mcp";
        CALDAV_MCP_LOG_FORMAT = "json";
        TZ = "America/Los_Angeles";
      };

      serviceConfig = {
        User = "caldav-mcp";
        Group = "caldav-mcp";
        ExecCondition = credentialsReady;
        ExecStart = lib.getExe package;
        EnvironmentFile = "-${secretFile}";
        Restart = "on-failure";
        RestartSec = 5;
        StateDirectory = "caldav-mcp";
        UMask = "0077";

        CapabilityBoundingSet = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
      };
    };
  };
}
