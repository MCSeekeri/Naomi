{ pkgs, lib, ... }:
{
  home = {
    activation = {
      TideConfigure =
        lib.hm.dag.entryAfter [ "writeBoundary" ]
          ''run ${pkgs.fish}/bin/fish -c "tide configure --auto --style=Rainbow --prompt_colors='16 colors' --show_time='24-hour format' --rainbow_prompt_separators=Angled --powerline_prompt_heads=Sharp --powerline_prompt_tails=Flat --powerline_prompt_style='Two lines, character and frame' --prompt_connection=Solid --powerline_right_prompt_frame=Yes --prompt_spacing=Sparse --icons='Many icons' --transient=Yes"'';
    };
    extraActivationPath = [ pkgs.babelfish ];
  };
}
