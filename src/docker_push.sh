# profiles are stored in ~/.aws/credentials
# the [britebrain-ecr] profile has write access to the ECR repository
IMAGE_NAME="britebrain-nginx"
export DOCKER_HOST=ssh://wouterd@192.168.2.70
aws ecr get-login-password --profile britebrain-ecr --region eu-west-1 | docker login --username AWS --password-stdin 394561805992.dkr.ecr.eu-west-1.amazonaws.com
docker tag $IMAGE_NAME-amd64:latest 394561805992.dkr.ecr.eu-west-1.amazonaws.com/$IMAGE_NAME:latest
docker push 394561805992.dkr.ecr.eu-west-1.amazonaws.com/$IMAGE_NAME:latest
unset DOCKER_HOST

