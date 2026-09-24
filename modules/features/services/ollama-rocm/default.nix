{ pkgs, ... }:

{
  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-rocm;
      host = "0.0.0.0";
      port = 11434;
      loadModels = [ "qwen2.5:14b" ];
      openFirewall = true;
    };
    resolved.enable = true;
  };
}
