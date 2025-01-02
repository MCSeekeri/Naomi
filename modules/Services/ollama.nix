{ ... }:
{
  services = {
    ollama = {
      enable = true;
      openFirewall = true;
      environmentVariables = {
        OLLAMA_MODELS = "/mnt/d2/ollama/models";
      };
      loadModels = [ "qwen2.5:0.5b" ];
    };
    open-webui = {
      enable = true;
      openFirewall = true;
      port = 4500;
    };
  };
}
