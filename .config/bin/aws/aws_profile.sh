AWS_PROFILE_PATH=~/.config/aws/current_profile.sh

case $1 in
"get")
  echo -e "AWS_PROFILE set to \e[32m$AWS_PROFILE\e[0m"
  ;;
"set")

  # Check if the profile exists
  if aws configure list-profiles | grep -q "$2"; then
    export AWS_PROFILE=$2
    mkdir -p $(dirname ${AWS_PROFILE_PATH})
    echo "export AWS_PROFILE=$2" >${AWS_PROFILE_PATH}
  else
    echo -e "Profile \e[31m$2\e[0m does not exist"
    exit 1
  fi

  # Check if AWS_PROFILE_PATH is in the PATH
  if [[ ":$PATH:" != *":$AWS_PROFILE_PATH:"* ]]; then
    export PATH=$PATH:$AWS_PROFILE_PATH

    # Get the zshrc dir from env, if not use standard
    ZSHRC_PATH=${ZSHRC_PATH:-~/.zshrc}
    echo "export PATH=\$PATH:$AWS_PROFILE_PATH" >>"$ZSHRC_PATH"
  fi

  echo -e "AWS_PROFILE set to \e[32m$AWS_PROFILE\e[0m"
  ;;

"unset")
  # Unset the profile
  unset AWS_PROFILE
  # Empty the content of the previously defined file
  if [ -f ${AWS_PROFILE_PATH} ]; then
    echo "" >${AWS_PROFILE_PATH}
  fi
  echo "AWS_PROFILE unset"
  ;;

*)
  echo "Invalid command. Available commands are:"
  echo "  get: Display the current AWS_PROFILE"
  echo "  set: Set a new AWS_PROFILE. Usage: set <profile_name>"
  echo "  unset: Unset the current AWS_PROFILE"
  ;;

esac
