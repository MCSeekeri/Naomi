{
  config,
  pkgs,
  inputs,
  ...
}:
{
  warnings =
    builtins.filter
      (
        _x:
        !(
          (config.virtualisation.podman.enable or false)
          || (config.virtualisation.docker.enable or false)
          || (config.virtualisation.libvirtd.enable or false)
        )
      )
      [
        ''
          Warning: 未启用任何容器或者虚拟化，可能无法正常使用 Winapps
        ''
      ];

  environment.systemPackages = with pkgs; [
    inputs.winapps.packages."${system}".winapps
    inputs.winapps.packages."${system}".winapps-launcher
    wineWowPackages.full
    winetricks
  ];
}
