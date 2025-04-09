{
  services = {
    ollama = {
      enable = true;
      port = 11434;
      # openFirewall = true; # Ollama 公网不鉴权，打开防火墙就过分了。
      environmentVariables = {
        # OLLAMA_MODELS = "/mnt/d2/ollama/models";
        # 根据具体位置修改
      };
      loadModels = [ "qwen2.5:1.5b" ];
    };
    nextjs-ollama-llm-ui = {
      enable = true;
      port = 11435;
      ollamaUrl = "http://127.0.0.1:11434";
      hostname = "0.0.0.0";
    };
  };
}
