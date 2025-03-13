{
  services.nginx = {
    enable = true;
    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    # recommendedProxySettings = true;
    # recommendedTlsSettings = true;
    recommendedZstdSettings = true;
    # 真是令人舒畅的配置
  };
}
