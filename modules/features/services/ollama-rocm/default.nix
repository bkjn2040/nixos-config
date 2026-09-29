{ pkgs, ... }:

{
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      host = "0.0.0.0";
      port = 11434;
      loadModels = [ "qwen3.5:9b" ];
      openFirewall = true;

      # Tool schemas for MCP integrations can exceed Ollama's 4096-token
      # default on GPUs with less than 24 GiB of VRAM.
      environmentVariables.OLLAMA_CONTEXT_LENGTH = "16384";
    };
  };

  # Ollama only probes accelerators once at startup. On this machine it can
  # otherwise start before amdgpu has registered the RX 6800 with KFD and
  # remain on the CPU until the service is restarted.
  systemd.services.ollama.serviceConfig.ExecStartPre = pkgs.writeShellScript "wait-for-rx-6800-rocm" ''
    for _ in $(seq 1 30); do
      for properties in /sys/class/kfd/kfd/topology/nodes/*/properties; do
        if [ -r "$properties" ] && grep -q '^device_id 29631$' "$properties"; then
          exit 0
        fi
      done
      sleep 1
    done

    echo "Timed out waiting for the RX 6800 ROCm device" >&2
    exit 1
  '';
}
