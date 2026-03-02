{ pkgs, lib, ... }:
{
  services = {
    ollama = {
      enable = lib.mkDefault true;
      port = 11434;
      # openFirewall = true; # Ollama 公网不鉴权，打开防火墙就过分了。
      environmentVariables = {
        # OLLAMA_MODELS = "/mnt/d2/ollama/models";
        # 根据具体位置修改
      };
      loadModels = lib.mkDefault [ "qwen3:0.6b" ];
    };
  };

  environment.systemPackages = with pkgs; [
    chatbox
    cherry-studio
  ];
}
