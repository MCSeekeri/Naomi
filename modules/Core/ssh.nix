{ pkgs, lib, ... }:
{
  services = {
    openssh = {
      enable = true;
      settings = {
        PermitEmptyPasswords = false;
        X11Forwarding = lib.mkDefault false; # 真的有人还用这个？
        ClientAliveInterval = 300;
        ClientAliveCountMax = 0;
        TCPKeepAlive = false;
        # AllowTcpForwarding = false; # 禁止 TCP 转发，我偶尔从设备跳转到路由器的时候会用到……
        AllowAgentForwarding = false;
        PermitRootLogin = "no"; # 禁止 root 远程登录
        Banner = "${pkgs.writeText "sshd-banner" ''
          UNAUTHORIZED ACCESS TO THIS DEVICE IS PROHIBITED
          禁止未经授权访问本设备

          You must have explicit, authorized permission to access or configure this device. Unauthorized attempts and actions to access or use this system may result in civil and/or criminal penalties. All activities performed on this device are logged and monitored.
          您必须具有明确的授权权限才能访问或配置此设备。未经授权尝试访问或使用本系统可能会导致民事和/或刑事处罚。在此设备上执行的所有活动都会被记录和监控。


        ''}";
      }; # 从 Reddit 抄的，好玩
      openFirewall = true;
    };
    fail2ban = {
      enable = true;
      ignoreIP = [
        "127.0.0.1"
        "192.168.0.0/16"
        "100.64.0.0/10" # tailscale 豁免
      ];
      maxretry = 5; # 我总是搞错密码
    };
  };
}
