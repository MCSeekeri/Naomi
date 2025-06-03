{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        lain-kde-splashscreen = pkgs.callPackage ./lain-kde-splashscreen { };
        aquanet = pkgs.callPackage ./aquanet { };
        aquadx = pkgs.callPackage ./aquadx { };
      };
    };
}
