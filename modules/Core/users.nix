{ ... }:
{
  users = {
    motdFile = "/etc/motd";
    mutableUsers = false; # 不允许在配置之外修改用户
  };
}
