{ lib, ... }: {
  programs.ghostty = {
    enable = true;
    settings = lib.mkDefault {
      font-size = 16;
      shell-integration-features = [
        "cursor"
        "sudo"
        "title"
        "ssh-env"
        "ssh-terminfo"
        "path"
      ];

      linux-cgroup = "single-instance";
      linux-cgroup-memory-limit = 2 * 1024 * 1024 * 1024;
    };
  };
}
