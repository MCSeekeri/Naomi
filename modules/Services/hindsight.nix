{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{

  services.postgresql = {
    enable = lib.mkDefault true;
    extensions = ps: [ ps.pgvector ];
    ensureDatabases = [ "hindsight" ];
    ensureUsers = [
      {
        name = "hindsight";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.postgresql-setup.postStart = lib.mkAfter ''
    psql -tAc "CREATE EXTENSION IF NOT EXISTS vector" hindsight
    psql -tAc "CREATE EXTENSION IF NOT EXISTS pg_trgm" hindsight
  '';

  users = {
    groups.hindsight = { };
    users.hindsight = {
      isSystemUser = true;
      group = "hindsight";
    };
  };

  sops.secrets.hindsight_env = {
    sopsFile = "${self}/secrets/services/hindsight.env";
    format = "dotenv";
    key = "";
    owner = "hindsight";
    group = "hindsight";
    mode = "0400";
  };

  systemd.services.hindsight = {
    description = "Hindsight agent memory server";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [
      "network-online.target"
      "postgresql.service"
      "postgresql-setup.service"
    ];
    requires = [
      "postgresql.service"
      "postgresql-setup.service"
    ];

    environment = {
      HOME = "/var/lib/hindsight";
      HINDSIGHT_API_HOST = "127.0.0.1";
      HINDSIGHT_API_PORT = "8888";
      HINDSIGHT_API_DATABASE_URL = "postgresql://hindsight@/hindsight?host=/run/postgresql";
      HINDSIGHT_API_DB_POOL_MIN_SIZE = "2";
      HINDSIGHT_API_DB_POOL_MAX_SIZE = "10";
      HINDSIGHT_API_VECTOR_EXTENSION = "pgvector";
      HINDSIGHT_API_LLM_PROVIDER = "openai";
      HINDSIGHT_API_LLM_BASE_URL = "https://api.siliconflow.cn/v1";
      HINDSIGHT_API_LLM_MODEL = "Qwen/Qwen3-8B";
      HINDSIGHT_API_RETAIN_MAX_COMPLETION_TOKENS = "32000";
      HINDSIGHT_API_LLM_TIMEOUT = "300";
      HINDSIGHT_API_REFLECT_LLM_TIMEOUT = "300";
      HINDSIGHT_API_LLM_REASONING_EFFORT = "low";
      HINDSIGHT_API_LLM_MAX_CONCURRENT = "4";
      HINDSIGHT_API_EMBEDDINGS_PROVIDER = "openai";
      HINDSIGHT_API_EMBEDDINGS_OPENAI_BASE_URL = "https://api.siliconflow.cn/v1";
      HINDSIGHT_API_EMBEDDINGS_OPENAI_MODEL = "Qwen/Qwen3-Embedding-0.6B";
      HINDSIGHT_API_DECISION_MODEL_PROVIDER = "typesafe";
      HINDSIGHT_API_RECALL_DECISION_MODEL_FALLBACK = "true";
      HINDSIGHT_API_RERANKER_PROVIDER = "siliconflow";
      HINDSIGHT_API_RERANKER_SILICONFLOW_MODEL = "BAAI/bge-reranker-v2-m3";
      HINDSIGHT_API_WORKER_ID = "hindsight";
      HINDSIGHT_API_LOG_LEVEL = "info";
    };

    serviceConfig = lib.serviceHardening {
      User = "hindsight";
      Group = "hindsight";
      StateDirectory = "hindsight";
      # systemd environment= 不允许换行符，EnvironmentFile 的单引号值支持跨行原样保留
      EnvironmentFile = [
        config.sops.secrets.hindsight_env.path
        (pkgs.writeText "hindsight-embeddings-prefix.env" "HINDSIGHT_API_EMBEDDINGS_QUERY_PREFIX='Instruct: Given a query about past conversations, retrieve relevant memories that answer the query\nQuery: '")
      ];
      ExecStart = "${pkgs.hindsight-api-slim}/bin/hindsight-api";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 75;
      ReadWritePaths = [ "/run/postgresql" ];
    };
  };
}
