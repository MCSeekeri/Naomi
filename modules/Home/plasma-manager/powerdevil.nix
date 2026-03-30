{ lib, ... }:
{
  programs = {
    plasma = {
      powerdevil = {
        battery = {
          powerButtonAction = lib.mkDefault "shutDown";
          powerProfile = lib.mkDefault "balanced";
        };
        AC = {
          powerButtonAction = lib.mkDefault "shutDown";
        };
        lowBattery = {
          powerButtonAction = lib.mkDefault "shutDown";
        };
      };
    };
  };
}
