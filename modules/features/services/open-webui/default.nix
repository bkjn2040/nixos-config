{ ... }:

{
  services.open-webui = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    openFirewall = true;

    environment.OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
  };
}
