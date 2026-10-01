{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.odysseus;
  upstreamCompose = builtins.readFile "${inputs.odysseus}/docker-compose.yml";

  # Open WebUI already listens on 8080 on workstation. Odysseus reaches
  # SearXNG over the private Compose network, so only its optional host-side
  # debugging port needs to move.
  composeFile = pkgs.writeText "odysseus-compose.yml" (
    builtins.replaceStrings
      [ ''- "127.0.0.1:8080:8080"'' ]
      [ ''- "127.0.0.1:${toString cfg.searxngPort}:8080"'' ]
      upstreamCompose
  );

  compose = lib.getExe pkgs.docker-compose;
  composeArgs =
    "--project-directory ${inputs.odysseus} --project-name odysseus -f ${composeFile}";
in
{
  options.services.odysseus = {
    enable = lib.mkEnableOption "Odysseus self-hosted AI workspace";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/odysseus";
      description = "Directory used for persistent Odysseus application data and logs.";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address on which the Odysseus web interface listens.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 7000;
      description = "Port on which the Odysseus web interface listens.";
    };

    searxngPort = lib.mkOption {
      type = lib.types.port;
      default = 8081;
      description = "Loopback port exposing the bundled SearXNG service for debugging.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.hasInfix ''- "127.0.0.1:8080:8080"'' upstreamCompose;
        message = "The upstream Odysseus Compose file changed; review the SearXNG port override.";
      }
    ];

    virtualisation.docker.enable = true;

    systemd = {
      tmpfiles.rules = [
        "d ${cfg.dataDir} 0750 root root - -"
        "d ${cfg.dataDir}/data 0750 1000 1000 - -"
        "d ${cfg.dataDir}/logs 0750 1000 1000 - -"
      ];

      services.odysseus = {
        description = "Odysseus self-hosted AI workspace";
        wantedBy = [ "multi-user.target" ];
        wants = [
          "docker.service"
          "network-online.target"
          "ollama.service"
        ];
        after = [
          "docker.service"
          "network-online.target"
          "ollama.service"
        ];

        environment = {
          APP_BIND = cfg.address;
          APP_PORT = toString cfg.port;
          APP_DATA_DIR = "${cfg.dataDir}/data";
          APP_LOGS_DIR = "${cfg.dataDir}/logs";
          # Odysseus runs in Docker, so its localhost is not the NixOS host.
          # Use the Compose host-gateway mapping and Ollama's OpenAI-compatible
          # API path, which is the endpoint shape Odysseus documents and probes.
          LLM_HOST = "host.docker.internal";
          OLLAMA_BASE_URL = "http://host.docker.internal:11434/v1";
          AUTH_ENABLED = "true";
          LOCALHOST_BYPASS = "false";
          PUID = "1000";
          PGID = "1000";
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${compose} ${composeArgs} up --detach --build --remove-orphans";
          ExecReload = "${compose} ${composeArgs} up --detach --build --remove-orphans";
          ExecStop = "${compose} ${composeArgs} down";
          TimeoutStartSec = "infinity";
          TimeoutStopSec = 120;
        };
      };
    };
  };
}
