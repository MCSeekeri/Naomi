_: {
  services = {
    sunshine = {
      enable = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  programs.moonlight-qt = {
    enable = true;
    capSysNice = true;
  };

}
