{ pkgs, ... }: {
  services = {
    sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
  environment.systemPackages = [ pkgs.moonlight-qt ];
}
