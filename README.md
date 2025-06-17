# Naomi

NAOMI: Aggregate Online Modular Infrastructure，简称 Naomi，是基于 NixOS 的“定制系统”。

[![built with garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2FMCSeekeri%2FNaomi&style=for-the-badge)](https://garnix.io/repo/MCSeekeri/Naomi)
![](https://img.shields.io/github/repo-size/MCSeekeri/Naomi?style=for-the-badge)
[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/MCSeekeri/Naomi)
## 简明安装指南

主要的安装方法有三种，使用修改后的镜像，使用官方镜像或使用 nixos-anywhere.\
其中 nixos-anywhere 适合在现有系统上进行清洁安装，但需要另一台正确安装并配置了 Nix 的设备。\
现有的设备代号[见此](docs/designator.md)，您也可以自定义设备代号与配置以适应不同需求。

> [!CAUTION]
> 安装过程会按照预置的磁盘规划进行格式化，请确保已备份重要数据。

### 使用修改后的安装镜像 (推荐)

参见 [相关文档](docs/livecd.md)

### 使用官方安装镜像

```
nix run --experimental-features "nix-command flakes" 'github:nix-community/disko/latest#disko-install' -- --flake github:MCSeekeri/Naomi#<设备代号> --disk main <设备文件位置>
```

官方安装镜像需手工配置`substituters`以加快在部分地区的下载速度，参见 [MirrorZ](https://help.mirrorz.org/nix-channels/) 的文档。

### 使用 nixos-anywhere

```
nix run github:nix-community/nixos-anywhere -- --build-on-remote --flake github:MCSeekeri/Naomi#<设备代号> --target-host root@<主机名>
```

由于某些原因，安装过程会编译部分没有二进制缓存的软件包，请坐和放宽，并听着[舒缓的新时代音乐](https://soundcloud.com/stanlepard/1996-internet-starter-kit-velkommen-original-mix)放松一下。

## 免责声明

由于 Naomi 目前仍在测试阶段，使用过程中可能会遇到系统不稳定，功能缺失，程序不兼容等问题。建议用户在非生产环境中使用，并定期备份重要数据。

## 参考资料

- [NixOS 官方文档](https://nixos.org/manual/)
- [Flake 非官方文档](https://nixos-and-flakes.thiscute.world/zh/)
- [一份适用于新手的参考配置](https://github.com/Misterio77/nix-starter-configs/)
- [比较完善的各类工具配置](https://gitlab.com/Zaney/zaneyos/)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
- [适合调试时聆听的放松音乐](https://www.youtube.com/watch?v=xxLpuXfnwkE)
