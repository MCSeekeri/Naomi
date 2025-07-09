{
  services.adguardhome = {
    enable = true;
    settings = {
      dns = {
        upstream_dns = [
          "https://doh.pub/dns-query"
          "https://cloudflare-dns.com/dns-query"
        ];
        bootstrap_dns = [
          "119.29.29.29"
          "119.28.28.28"
          "223.5.5.5"
          "223.6.6.6"
          "1.1.1.1"
          "1.0.0.1"
          "2402:4e00::"
          "2400:3200::1"
          "2606:4700:4700::1111"
        ];
      };
      filters = [
        {
          enabled = true;
          url = "https://gcore.jsdelivr.net/gh/TG-Twilight/AWAvenue-Ads-Rule@main/AWAvenue-Ads-Rule.txt";
          name = "AWAvenue Ads Rule";
          id = 114;
        }
        {
          enabled = true;
          url = "https://anti-ad.net/easylist.txt";
          name = "CHN=anti-AD";
          id = 810;
        }
      ];
    };
  };
}
