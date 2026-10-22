{
  config,
  lib,
  pkgs,
  ...
}:
let
  assets = pkgs.runCommandLocal "iis-camouflage-assets" { } ''
    mkdir -p $out
    cp ${./legacy/iisstart.htm} $out/iisstart.htm
    cp ${./legacy/iisstart.png} $out/iisstart.png
  '';

  camouflage = ''
    header {
      -Via
      Server "Microsoft-IIS/10.0"
      X-Powered-By "ASP.NET"
    }

    handle_errors {
      @iis expression {http.error.status_code} in [401, 403, 404, 405, 406, 412, 500, 501, 502]
      handle @iis {
        header Content-Type "text/html"
        header Server "Microsoft-IIS/10.0"
        header X-Powered-By "ASP.NET"
        header -Etag
        header -Last-Modified
        header -Accept-Ranges
        root * ${./legacy}
        rewrite * /{http.error.status_code}.htm
        file_server
      }
      handle {
        header -Server
        header Content-Type "text/html"
        respond `<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
    <html><head>
    <title>{http.error.status_code} Error</title>
    </head><body>
    <h1>{http.error.status_code} Error</h1>
    <hr>
    <address>Microsoft-IIS/10.0</address>
    </body></html>` {http.error.status_code}
      }
    }
  '';

  defaultSite = ''
    @htm path / /iisstart.htm
    header @htm Content-Type "text/html"
    header @htm Last-Modified "Wed, 16 Jan 2019 03:41:00 GMT"
    header @htm ETag `"d3c4f6a8b2e1:0"`

    @home path /
    rewrite @home /iisstart.htm

    handle {
      root * ${assets}
      file_server
    }
  '';
in
{
  options.services.caddy.iisCamouflage = {
    excludeHosts = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "不参与伪装的站点";
    };
    site = lib.mkOption {
      type = lib.types.lines;
      default = defaultSite;
      description = "IIS 默认站";
    };
    fragment = lib.mkOption {
      type = lib.types.lines;
      default = camouflage;
      description = "响应头与错误页片段";
    };
    transform = lib.mkOption {
      type = lib.types.raw;
      description = "包装 virtualHosts";
    };
  };

  config.services.caddy.iisCamouflage.transform =
    vhosts:
    lib.mapAttrs (
      name: vhost:
      vhost
      // {
        extraConfig = lib.mkMerge [
          (lib.mkIf (!builtins.elem name config.services.caddy.iisCamouflage.excludeHosts) (
            lib.mkBefore camouflage
          ))
          (vhost.extraConfig or "")
        ];
      }
    ) vhosts;
}
