{
  services.privatebin = {
    enable = true;
    enableNginx = true; # 80 端口打架，搞不懂。
    # virtualHost = "";
    #
    poolConfig = { };
    settings = {
      main = {
        languagedefault = "zh";
        sizelimit = 52428800; # 50MiB
        fileupload = true;
      };
      model = {
        class = "Filesystem"; # 也可以考虑 S3
      };
    };
  };
}
