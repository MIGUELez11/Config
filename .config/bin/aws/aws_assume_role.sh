#!/bin/bash
save_previous_role() {
  if [ ! -z "$AWS_ACCOUNT_ID" ]; then
    PREV_AWS_ACCOUNT_ID=$AWS_ACCOUNT_ID
    PREV_AWS_ROLE_NAME=$AWS_ROLE_NAME
    PREV_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
    PREV_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
    PREV_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
    PREV_AWS_ROLE_ARN=$AWS_ROLE_ARN
    PREV_AWS_CREDENTIALS=$AWS_CREDENTIALS
  fi
}

restore_previous_role() {
    export AWS_ACCOUNT_ID=$PREV_AWS_ACCOUNT_ID
    export AWS_ROLE_NAME=$PREV_AWS_ROLE_NAME
    export AWS_ACCESS_KEY_ID=$PREV_AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=$PREV_AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN=$PREV_AWS_SESSION_TOKEN
    export AWS_ROLE_ARN=$PREV_AWS_ROLE_ARN
    export AWS_CREDENTIALS=$PREV_AWS_CREDENTIALS
}

clean_variables() {
  unset PREV_AWS_ACCOUNT_ID
  unset PREV_AWS_ROLE_NAME
  unset PREV_AWS_ACCESS_KEY_ID
  unset PREV_AWS_SECRET_ACCESS_KEY
  unset PREV_AWS_SESSION_TOKEN
  unset PREV_AWS_ROLE_ARN
  unset PREV_AWS_CREDENTIALS
}

clean_role() {
  unset AWS_ACCOUNT_ID
  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset AWS_SESSION_TOKEN
  unset AWS_ROLE_ARN
  unset AWS_ROLE_NAME
  unset AWS_CREDENTIALS
}

store_used_profiles() {
  used_profiles_file=~/.aws/used_profiles
  touch $used_profiles_file

  if ! grep -Fxq "$1" $used_profiles_file
  then
      echo "$1" >> $used_profiles_file
  fi
}



save_previous_role

if [[ $1 =~ "/" ]]; then
  ADDR=("${(@s:/:)1}")
  AWS_ACCOUNT_ID=${ADDR[1]}
  AWS_ROLE_NAME=${ADDR[2]}
else
  AWS_ACCOUNT_ID=$1
  AWS_ROLE_NAME=$2
fi

if [ -z "$AWS_ACCOUNT_ID" ] && [ -z "$AWS_ROLE_NAME" ]; then
  clean_role
  clean_variables

  echo "AWS credentials cleaned"
  return
fi


AWS_ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/${AWS_ROLE_NAME}"
AWS_CREDENTIALS=$(aws sts assume-role --role-arn "${AWS_ROLE_ARN}" --role-session-name AWSCLI-Session)

if [ -z "$AWS_CREDENTIALS" ]; then
  echo "Failed to assume role"

  if [ ! -z "$PREV_AWS_ACCOUNT_ID" ]; then
    restore_previous_role
  else
    clean_role
  fi

  clean_variables
  return
fi


export AWS_ACCESS_KEY_ID=$(echo "$AWS_CREDENTIALS" | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo "$AWS_CREDENTIALS" | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo "$AWS_CREDENTIALS" | jq -r '.Credentials.SessionToken')

store_used_profiles "$AWS_ACCOUNT_ID"/"$AWS_ROLE_NAME"
clean_variables

echo "AWS role ${AWS_ROLE_ARN} assumed"
