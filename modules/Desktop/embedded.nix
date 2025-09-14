{ pkgs, ... }:
{
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

    gcc-arm-embedded # arm-none-eabi-gcc
    openocd

    stlink
    stlink-gui
    stlink-tool

    SDL2 # 存疑

    dfu-util
    dfu-programmer

    uv

    # nur.repos.Emin017.lceda-pro # 用 flatpak

    # [TODO] 等待后续完善
  ];
}
