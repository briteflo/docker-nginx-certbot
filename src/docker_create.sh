#!/bin/bash

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <arm|amd>"
    exit 1
fi

TIMESTAMP=$(date +"%Y%m%d%H%M%S")


case $1 in
    'arm')
        echo "will build for arm on local machine"
        ;;
    'amd64')
        echo "will build for amd64 on remote machine"
        export DOCKER_HOST=ssh://wouterd@192.168.2.70
        ;;
    *)
        echo "Invalid argument. Please use either 'arm' or 'amd64'."
        exit 1
        ;;
esac


# Define the Docker image name
IMAGE_NAME="britebrain-nginx"

docker login

# cleanup
#docker system prune -af

docker build --tag $IMAGE_NAME-$1-0.0.1 --tag $IMAGE_NAME-$1-$TIMESTAMP --tag $IMAGE_NAME --tag $IMAGE_NAME-$1 .

echo 'container build done'

case $1 in
    'arm')
        # remove old container
        docker stop $IMAGE_NAME || true && docker rm $IMAGE_NAME || true

        # Run the Docker container
        docker run -d \
            --name $IMAGE_NAME \
            -p 80:80 -p 443:443 \
            --env CERTBOT_EMAIL=wouter@briteflo.com $IMAGE_NAME-arm

        # docker run -d -p 80:80 -p 443:443 --env CERTBOT_EMAIL=wouter@briteflo.com britebrain/nginx
        # docker run -it -p 80:80 -p 443:443 --env CERTBOT_EMAIL=wouter@briteflo.com britebrain/nginx

            # -v $(pwd)/nginx_secrets:/etc/letsencrypt \
            # -v $(pwd)/user_conf.d:/etc/nginx/user_conf.d:ro \        

        ;;
    'amd64')
        unset DOCKER_HOST
        ;;
esac





