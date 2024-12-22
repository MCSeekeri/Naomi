# Naomi
NAOMI: Aggregate Online Modular Infrastructure，简称 Naomi，是基于 NixOS 的“定制系统”。

## 硬件要求
理论上，系统兼容与 NixOS 官方一致，但目前主要针对使用 Intel 处理器搭配 Nvidia Turing 或更新架构显卡的设备进行开发。

## 简明安装指南
设备代号[见此](docs/designator.md)
1. 下载 NixOS 24.11 版本镜像，并制作启动盘。
2. 启动后，将本项目全部代码复制到 /tmp/Naomi 目录。
3. 执行 `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount --yes-wipe-all-disks /tmp/Naomi/hosts/<设备代号>/disk-config.nix` 并等待完成。
> [!WARNING]
> 这一步会格式化硬盘并按照预置的方式进行分区，默认设备为 /dev/sda。
4. `nixos-install --flake /tmp/Naomi#<设备代号>`并在终端提示时全部输入`y`以确认。\
如果您位于中国大陆，请在命令后附上：`--option substituters "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"`以尽可能加快安装过程。
5. 由于某些原因，安装过程会编译部分没有二进制缓存的软件包，请坐和放宽，并听着[舒缓的新时代音乐](https://soundcloud.com/stanlepard/1996-internet-starter-kit-velkommen-original-mix)放松一下。

## 免责声明
由于 Naomi 目前仍在测试阶段，使用过程中可能会遇到系统不稳定，功能缺失，程序不兼容等问题。建议用户在非生产环境中使用，并定期备份重要数据。

## 参考资料
- [NixOS 官方文档](https://nixos.org/manual/)
- [Flake 非官方文档](https://nixos-and-flakes.thiscute.world/zh/)
- [一份适用于新手的参考配置](https://github.com/Misterio77/nix-starter-configs/)
- [Awesome Nix](https://github.com/nix-community/awesome-nix)
- [适合调试时聆听的舒缓放松音乐](https://www.youtube.com/watch?v=NaDn0dF7bBk)