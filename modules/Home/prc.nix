{
  programs = {
    librewolf = {
      languagePacks = [ "zh-CN" ];
      policies.RequestedLocales = [ "zh-CN" ];
    };
    plasma.configFile."plasma-localerc" = {
      "Formats"."LANG" = "zh_CN.UTF-8";
      "Translations"."LANGUAGE" = "zh_CN";
    };
  };
}
