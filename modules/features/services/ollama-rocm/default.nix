{ config, pkgs, ... }:

{
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      host = "0.0.0.0";
      port = 11434;
    };
    resolved.enable = true;
  };

  systemd.services.ollama-prime-qwen = {
    description = "Pre-load Qwen2.5 model into Ollama";
    after = [ "ollama.service" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      while ! ${pkgs.curl}/bin/curl -s http://127.0.0.1:11434 > /dev/null; do
        sleep 2
      done
      ${config.services.ollama.package}/bin/ollama pull qwen2.5:14b
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 11434 ];
}
