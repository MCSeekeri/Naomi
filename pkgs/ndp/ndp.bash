_ndp_configs() {
  local project_root
  local dir

  if [[ -n ${PRJ_ROOT:-} && -d ${PRJ_ROOT}/hosts ]]; then
    project_root=${PRJ_ROOT}
  elif [[ -d ${PWD}/hosts ]]; then
    project_root=${PWD}
  else
    return 0
  fi

  for dir in "${project_root}"/hosts/*; do
    [[ -d ${dir} ]] && basename "${dir}"
  done
}

_ndp_set_compreply() {
  local output

  if output="$("$@")"; then
    if [[ -n ${output} ]]; then
      mapfile -t COMPREPLY <<<"${output}"
    else
      COMPREPLY=()
    fi
  else
    COMPREPLY=()
  fi
}

_ndp() {
  local current previous
  local configs

  COMPREPLY=()
  current=${COMP_WORDS[COMP_CWORD]}
  previous=${COMP_WORDS[COMP_CWORD - 1]}

  if [[ ${previous} == -p || ${previous} == --port ]]; then
    return 0
  fi

  case ${COMP_CWORD} in
  1)
    configs="$(_ndp_configs)" || configs=""
    _ndp_set_compreply compgen -W "${configs}" -- "${current}"
    return 0
    ;;
  2)
    _ndp_set_compreply compgen -A hostname -P "${USER}@" -- "${current}"
    return 0
    ;;
  3)
    _ndp_set_compreply compgen -W "build push dry-activate test switch boot" -- "${current}"
    return 0
    ;;
  *)
    ;;
  esac

  _ndp_set_compreply compgen -W "-p --port -S --ask-sudo-password --no-substitutes --show-trace --impure --" -- "${current}"
}

complete -F _ndp ndp
