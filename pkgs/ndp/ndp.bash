_ndp_configs() {
  local project_root
  local dir

  if [[ -n ${PRJ_ROOT:-} && -d ${PRJ_ROOT}/hosts ]]; then
    project_root=$PRJ_ROOT
  elif [[ -d $PWD/hosts ]]; then
    project_root=$PWD
  else
    return 0
  fi

  for dir in "$project_root"/hosts/*; do
    [[ -d $dir ]] && basename "$dir"
  done
}

_ndp() {
  local current previous

  COMPREPLY=()
  current=${COMP_WORDS[COMP_CWORD]}
  previous=${COMP_WORDS[COMP_CWORD - 1]}

  if [[ $previous == -p || $previous == --port ]]; then
    return 0
  fi

  case $COMP_CWORD in
    1)
      COMPREPLY=($(compgen -W "$(_ndp_configs)" -- "$current"))
      return 0
      ;;
    2)
      COMPREPLY=($(compgen -A hostname -P "${USER}@" -- "$current"))
      return 0
      ;;
    3)
      COMPREPLY=($(compgen -W "build push dry-activate test switch boot" -- "$current"))
      return 0
      ;;
  esac

  COMPREPLY=($(compgen -W "-p --port -S --ask-sudo-password --no-substitutes --show-trace --impure" -- "$current"))
}

complete -F _ndp ndp
