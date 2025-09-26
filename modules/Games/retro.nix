{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (retroarch.withCores (
      cores: with cores; [
        # 京都水泥厂
        mesen
        bsnes
        mgba
        gambatte
        mupen64plus
        # 所有的游戏在这里集结
        swanstation
        pcsx2
        # 汤川专务
        flycast
        genesis-plus-gx
        # 凶
        bluemsx
      ]
    ))

    retroarch-assets
    retroarch-joypad-autoconfig

    ryubing

    duckstation
    pcsx2
    ppsspp
    rpcs3

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
