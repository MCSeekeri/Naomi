{ inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.age = {
    # 设备部署之后，反过来复制密钥，然后添加到 Github Repo
    # TODO: 未来优化一下这个流程
    keyFile = "/var/lib/sops-nix/key.txt";
    generateKey = true;
  };
}
