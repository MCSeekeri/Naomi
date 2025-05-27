{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    retroarch
    retroarch-assets
    retroarch-joypad-autoconfig

    # 京都水泥厂
    libretro.mesen
    libretro.bsnes
    libretro.mgba
    libretro.gambatte
    libretro.mupen64plus
    ryubing

    # 所有的游戏在这里集结
    libretro.beetle-psx
    libretro.beetle-psx-hw
    libretro.pcsx2
    ppsspp
    rpcs3

    # 汤川专务
    libretro.flycast
    libretro.genesis-plus-gx

    # 凶
    libretro.bluemsx
    xemu

    # oremoR nhoJ ,em llik tsum uoy emag eht niw oT
    dsda-doom
    dsda-launcher
    gzdoom
    ecwolf

    # 640KiB
    dosbox-x
  ];
}
