{ pkgs, ... }:
{
  # 谨以此配置文件，献给精通嵌入式开发的天才变态冒失娘二游痴美少女
  # 这人哪哪都好，可惜沾上粥和少前了……
  environment.systemPackages = with pkgs; [
    arduino
    arduino-cli
    arduino-ide
    arduino-language-server

    libgcc
    gnumake
    gdb
    sdcc
    cmake
    libusb1
    binutils
    imsprog
    ch341eeprom

    stm32cubemx
    stm32flash
    stm32loader
    # stm32cubeide # 会导致 CI 全部失败，这事情得怪 ST
    # nix-store --add-fixed sha256 st-stm32cubeide_1.19.0_25607_20250703_0907_amd64.sh.zip

    gcc-arm-embedded # arm-none-eabi-gcc
    openocd

    stlink
    stlink-gui
    stlink-tool

    SDL2 # 存疑

    dfu-util
    dfu-programmer

    uv

    # [TODO] 等待后续完善
  ];

  services.flatpak.packages = [ "cn.lceda.LCEDAPro" ];

  environment.sessionVariables = {
    WEBKIT_DISABLE_COMPOSITING_MODE = "1"; # 日食的黑色主题需要
  };
}
