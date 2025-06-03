# 安装镜像简易说明

## 生成镜像

首先，你需要一个 Nix 环境，并且安装了 nixos-rebuild，安装步骤在此不再赘述。

```nix
nixos-rebuild build-image --flake .#cuba --image-variant iso-installer
```

如果一切正常，终端会提示输出的 ISO 路径，将其中的 ISO 复制到启动介质中，在此推荐使用 [Ventoy](https://www.ventoy.net) 启动。

## 启动后

cuba 镜像设计之初是为了解决远程协助安装的问题，因此启动后会自动建立 Onion 服务并试图连接，同时考虑到国内的网络环境，也会使用 bore 来公开 SSH 服务。\
服务启动完毕后，会自动生成二维码，二维码包含当前 root 密码，本地网络地址，Onion 服务地址和 bore 地址。
![](https://github.com/MCSeekeri/storage/raw/main/docs/livecd_qrcode.webp)
如果您不需要使用 SSH 远程安装，请 Ctrl-C 回到终端，然后输入以下命令

```nix
disko-install -f github:MCSeekeri/Naomi#<设备代号> --disk main <设备文件位置>
```

> [!CAUTION]
> 安装过程会按照预置的磁盘规划进行格式化，请确保已备份重要数据。

极少数情况下，`disko-install` 会遇到一些无法预知的问题，此时需要分别运行`disko` 和 `nixos-install`

```nix
disko -f github:MCSeekeri/Naomi#<设备代号>
nixos-install --root /mnt --flake github:MCSeekeri/Naomi#<设备代号>
```

如果仍然无法正常安装，请手动使用`cfdisk`分区，格式化，同时依照`disko-config.nix`中的名称设置分区标签，挂载到 `/mnt` 目录，然后再次运行`nixos-install`

> [!NOTE]
> 考虑到国内的网络环境，镜像内预置了 Geph 5,Proxychains-ng 和 Clash-rs，必要时还可以通过配置 [dae](https://github.com/daeuniverse/dae) 来更好的实现透明代理和流量分流。
