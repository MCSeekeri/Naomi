{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        geph5-client = pkgs.callPackage ./geph5-client { };
        lain-kde-splashscreen = pkgs.callPackage ./lain-kde-splashscreen { };
        aquanet = pkgs.callPackage ./aquanet { };
        aquadx = pkgs.callPackage ./aquadx { };
      };
    };
}
