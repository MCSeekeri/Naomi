{
  services.privatebin = {
    enable = true;
    poolConfig = { };
    settings = {
      main = {
        sizelimit = 52428800; # 50MiB
        fileupload = true;
      };
      model = {
        class = "Filesystem"; # 也可以考虑 S3
      };
      traffic = {
        limit = 10;
        header = "X_FORWARDED_FOR";
      };
      purge = {
        limit = 300;
        batchsize = 10;
      };
    };
  };
}
