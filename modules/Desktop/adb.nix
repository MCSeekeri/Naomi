{ pkgs, ... }:
{
  services.udev.packages = with pkgs; [ android-udev-rules ];
  programs.adb.enable = true;
  environment.systemPackages = with pkgs; [
    android-tools
    scrcpy
    qtscrcpy
    android-file-transfer
    android-backup-extractor
    payload-dumper-go
  ];
}
