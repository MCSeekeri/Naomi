{ config, lib, ... }:
{
  # 这玩意的目录结构乱的一批，用标准打包甚至能整出来 /var/lib/cowrie/var/lib/cowrie/downloads 这种令人反胃的地址
  # 摆了，直接上容器

  virtualisation.oci-containers.containers.cowrie = {
    image = "docker.io/cowrie/cowrie:latest";
    ports = [
      "22:22/tcp"
      "23:23/tcp"
      "127.0.0.1:9000:9000/tcp"
    ];
    volumes = [
      "cowrie-etc:/cowrie/cowrie-git/etc"
      "cowrie-var:/cowrie/cowrie-git/var"
      "cowrie-fs:/cowrie/cowrie-git/honeyfs"
    ];
    environment = lib.mkDefault {
      COWRIE_STDOUT = "yes";
      COWRIE_HONEYPOT_HOSTNAME = config.networking.hostName;
      COWRIE_SHELL_KERNEL_VERSION = "2.6.32-71.el6.x86_64";
      COWRIE_SHELL_KERNEL_BUILD_STRING = "#1 SMP Fri May 20 03:43:02 2011";
      COWRIE_SHELL_SSH_VERSION = "OpenSSH_5.3p1, OpenSSL 1.0.0 29 Mar 2010"; # 用 ssh-audit 能看出来问题，没法精确模拟陈年 CentOS
      COWRIE_SSH_LISTEN_ENDPOINTS = "tcp:22:interface=0.0.0.0";
      COWRIE_SSH_VERSION = "SSH-2.0-OpenSSH_5.3";
      COWRIE_SSH_AUTH_KEYBOARD_INTERACTIVE_ENABLED = "yes";
      COWRIE_SSH_PUBLIC_KEY_AUTH = "ssh-rsa,ecdsa-sha2-nistp256";
      COWRIE_SSH_CIPHERS = "aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc";
      COWRIE_SSH_MACS = "hmac-sha1,hmac-md5,hmac-sha1-96";
      COWRIE_TELNET_ENABLED = "yes";
      COWRIE_TELNET_LISTEN_ENDPOINTS = "tcp:23:interface=0.0.0.0";
      COWRIE_OUTPUT_PROMETHEUS_ENABLED = "yes";
    };
    extraOptions = [ "--cap-add=NET_BIND_SERVICE" ];
  };
}
