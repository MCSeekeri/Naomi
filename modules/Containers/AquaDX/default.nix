{ pkgs, ... }:
{
  networking.firewall.allowedTCPPorts = [
    80
    8443
    22345
  ];
  virtualisation.arion.projects.aquadx = {
    serviceName = "aquadx";
    settings = {
      services.aquadx_app.service = {
        build.context = "https://github.com/MewoLab/AquaDX.git#v1-dev";
        ports = [
          "80:80"
          "8443:8443"
          "22345:22345"
        ];
        restart = "on-failure:3";
        environment = {
          SPRING_DATASOURCE_URL = "jdbc:mariadb://aquadx_db:3306/main";
          SPRING_DATASOURCE_USERNAME = "cat";
          SPRING_DATASOURCE_PASSWORD = "meow";
          SPRING_DATASOURCE_DRIVER_CLASS_NAME = "org.mariadb.jdbc.Driver";
        };
        depends_on = [ "aquadx_db" ];
        volumes = [
          "${builtins.path { path = ./application.properties; }}:/app/config/application.properties"
          "aquadx_data:/app/data"
        ];
      };
      services.aquadx_db.service = {
        image = "mariadb:latest";
        environment = {
          MYSQL_ROOT_PASSWORD = "meow";
          MYSQL_DATABASE = "main";
          MYSQL_USER = "cat";
          MYSQL_PASSWORD = "meow";
        };
        ports = [ "127.0.0.1:3369:3306" ];
        volumes = [ "aquadx_mariadb_data:/var/lib/mysql" ];
      };

      docker-compose.volumes = {
        aquadx_data = { };
        aquadx_mariadb_data = { };
      };
    };
  };
}
