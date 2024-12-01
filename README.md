# Naomi
NAOMI: Aggregate Online Modular Infrastructure，简称 Naomi，是基于 NixOS 的“定制系统”。 

## 硬件要求
理论上，系统兼容所有使用 Intel 处理器搭配 Nvidia Turing 或更新架构显卡的设备。\
其余硬件要求请参考 NixOS 官方文档。

## 简明安装指南
1. 下载 NixOS 24.11 版本镜像，并制作启动盘。
2. 进行磁盘分区操作，并挂载分区至 /mnt.
3. `nixos-generate-config --root /mnt` 生成 NixOS 配置文件。
4. 复制所有内容至 /mnt/etc/nixos/ 下。
5. `nixos-install`
如果您位于中国大陆，请使用以下命令：`nixos-install --option substituters "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"`

## 免责声明
由于 Naomi 目前仍在测试阶段，使用过程中可能会遇到系统不稳定，功能缺失，程序兼容性等问题。建议用户在非生产环境中使用，并定期备份重要数据。
