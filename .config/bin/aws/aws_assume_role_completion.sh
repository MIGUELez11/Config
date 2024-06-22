_aws_assume_role()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  opts="get set unset"

  used_profiles_file=~/.aws/used_profiles

  if [[ ${COMP_CWORD} -eq 1 ]] && [ -f $used_profiles_file ]; then
    opts=$(cat $used_profiles_file)
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
  fi
}

complete -F _aws_assume_role aws_assume_role.sh

