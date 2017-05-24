#!/bin/sh

BACKUP_FILE=backup-$(date -I).tar
AWS_ACCESS_KEY=$(cat /run/secrets/aws_access_key)
AWS_SECRET_KEY=$(cat /run/secrets/aws_secret_key)

# Configure the AWS CLI
echo "[default]" > /root/.aws/config
echo "region = $AWS_REGION" >> /root/.aws/config
echo "[default]" > /root/.aws/credentials
echo "aws_access_key_id = $AWS_ACCESS_KEY" >> /root/.aws/credentials 
echo "aws_secret_access_key = $AWS_SECRET_KEY" >> /root/.aws/credentials

# Identify the version of UCP to use
export UCP_IMAGE=docker/ucp:$(docker inspect --format='{{.Config.Image}}' ucp-proxy | awk -F: '{print $2}')

# Run a backup of the UCP Controller
echo y | docker run --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock $UCP_IMAGE backup --interactive > /tmp/$BACKUP_FILE

# Copy backup.tar to the S3 bucket
aws s3 cp /tmp/$BACKUP_FILE s3://$AWS_BUCKET
