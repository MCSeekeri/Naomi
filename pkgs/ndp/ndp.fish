function __ndp_project_root
  if set -q PRJ_ROOT
    if test -d "$PRJ_ROOT/hosts"
      echo "$PRJ_ROOT"
      return 0
    end
  end

  if test -d hosts
    pwd
  end
end

function __ndp_configs
  set -l root (__ndp_project_root)

  if test -z "$root"
    return 0
  end

  for dir in "$root"/hosts/*
    if test -d "$dir"
      path basename "$dir"
    end
  end
end

complete -c ndp -f
complete -c ndp -n '__fish_is_nth_token 1' -a '(__ndp_configs)' -d 'NixOS 配置名'
complete -c ndp -n '__fish_is_nth_token 2' -a '(__fish_complete_user_at_hosts)' -d 'SSH 目标主机'
complete -c ndp -n '__fish_is_nth_token 3' -a 'build push dry-activate test switch boot' -d '部署动作'
complete -c ndp -s p -l port -r -d 'SSH 端口'
complete -c ndp -s S -l ask-sudo-password -d '激活前先验证 sudo'
complete -c ndp -l no-substitutes -d '执行 nix copy 时禁用替代源'
complete -c ndp -l show-trace -d '将 --show-trace 传递给 nix build'
complete -c ndp -l impure -d '将 --impure 传递给 nix build'
