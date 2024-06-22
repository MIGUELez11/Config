ORIGIN_ACCOUNT=$1
DESTINY_ACCOUNT=$2

login_if_expired() {
  aws sts get-caller-identity >/dev/null

  if [ $? -ne 0 ]; then
    echo "Login in $1"
    aws sso login
  fi
}

AWS_PROFILE=$ORIGIN_ACCOUNT
login_if_expired $ORIGIN_ACCOUNT

ORIGIN_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r ".Account")
echo $ORIGIN_ACCOUNT_ID
REPOS=$(aws ecr describe-repositories | jq -r ".repositories[].repositoryName")
ORIGIN_DOCKER_TOKEN=$(aws ecr get-login-password --region=eu-west-1)

AWS_PROFILE=$DESTINY_ACCOUNT
login_if_expired $DESTINY_ACCOUNT

DESTINY_ACCOUNT_ID=$(aws sts get-caller-identity | jq -r ".Account")
echo $DESTINY_ACCOUNT_ID

# echo $ORIGIN_DOCKER_TOKEN | docker login --username AWS --password-stdin $ORIGIN_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com

# for repo in $REPOS
# do
#   docker pull $ORIGIN_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/$repo:dev
# done

DESTINY_DOCKER_TOKEN=$(aws ecr get-login-password --region=eu-west-1)
echo $DESTINY_DOCKER_TOKEN | docker login --username AWS --password-stdin $DESTINY_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com

for repo in $REPOS; do
  # docker tag $ORIGIN_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/$repo:dev $DESTINY_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/$repo:dev
  docker push $DESTINY_ACCOUNT_ID.dkr.ecr.eu-west-1.amazonaws.com/$repo:dev
done
