{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "xfs";
                extraArgs = [
                  "-f"
                  "-K"
                ];
                mountpoint = "/";
                mountOptions = [
                  "defaults"
                  "noatime"
                  "pquota"
                  "logbsize=256k"
                ];
              };
            };
          };
        };
      };
    };
  };
}
