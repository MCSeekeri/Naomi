{
  programs = {
    plasma = {
      powerdevil = {
        battery = {
          powerButtonAction = "shutDown";
          powerProfile = "balanced";
        };
        AC = {
          powerButtonAction = "shutDown";
        };
        lowBattery = {
          powerButtonAction = "shutDown";
        };
      };
    };
  };
}
