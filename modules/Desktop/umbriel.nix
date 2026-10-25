{ self, ... }: {
  imports = [ "${self}/modules/Desktop/gui.nix" ];
  programs.umbriel.enable = true;
}
