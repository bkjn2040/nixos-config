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
    };
  };
}
