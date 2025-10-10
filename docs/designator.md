# 预置的设备配置及代号

- `manhattan`: QEMU 虚拟机，目前主要的测试对象。
- `cyprus`: Lenovo Y7000P，用于开发的笔记本，同时也是主要游戏设备。
- `seychelles`: Lenovo ThinkStation PX，用于模型训练的工作站。
- `costarica`: VMware 虚拟机，用于搭建各类游戏服务器。
- `cuba`: 用于生成 Live CD 的配置，目前仅用于测试。

# 自定义

如果您需要添加新的设备配置和账户配置，请在 Fork 之后修改。\
Naomi 设计之初就考虑了最终用户自定义的情况，因此大部分配置都是模块，请自行按需导入。\
`hosts/<代号>/default.nix`写引入的模块，`hosts/<代号>/disko-config.nix`写磁盘分区配置，借鉴现有的范例即可。\
`modules/` 目录下的模块按照以下几个分类进行组织：

- `Core` 字面意思上的基础，包含了大部分常见配置，比如启动配置，终端设置，内存压缩等，这部分基本按照最推荐的状态设置，直接引入整个文件夹即可。
- `Desktop` 包含桌面用户常见软件配置，比如 ToDesk，月光，Steam，输入法等，需要注意的是这里是全局生效的配置，影响所有用户。
- `Server` 服务器常见软件配置，比如 ClamAV，防火墙，虚拟化配置，按需选择即可。
- `Services` 服务配置，比如 nginx，Ollama，AdGuard Home 等，受限于作者水准，只预置了最入门的一些配置。
- `Games` 游戏服务器配置，比如 Minecraft，某个八按钮音乐游戏等，这部分基本难以做到开箱即用，需要手工处理很多东西，仅供思路参考。
- `Home` Home-Manager 独占内容，需要在`users/`下的用户配置中引用，包含浏览器，用户界面，Shell 设置等，仅作基础配置，仍然需要用户来自定义个性化配置。
- `Containers` Docker Compose on Nix，目前选择的解决方案是 Arion，也许未来会换成别的，但至少现在仍然能凑合用。
- `Hardware` 一个大而全的配置文件，受限于 Nix 对环境的限制，目前需要用户手工配置 CPU 和 GPU 品牌。
