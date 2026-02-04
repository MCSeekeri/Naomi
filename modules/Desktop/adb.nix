{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    android-tools
    scrcpy
    qtscrcpy
    android-file-transfer
    android-backup-extractor
    payload-dumper-go
  ];
}
