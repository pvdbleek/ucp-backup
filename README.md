# UCP Backup Container
A container to be used in an Docker EE environment.
It runs a scheduled backup through cron and uploads the backup tar file to an S3 bucket.

## Getting started

### Clone the git repo

```git clone https://github.com/pvdbleek/ucp-backup```

### Adjust the Dockerfile
The default schedule in the Dockerfile is every night at 1.10AM.
You might want to adjust that to your preferred time.

### Build & push the image

```docker build -t <namespace>/<repository> .```

```docker push <namespace>/<repository>```

### Deploy AWS S3 credentials to Docker Swarm secrets

Assuming you know how to set up an S3 bucket and IAM access:
Create two secrets in swarm:

```echo <your_aws_access_key> | docker secret create aws_access_key -```

```echo <your_aws_secret_key> | docker secret create aws_secret_key -```

### Deploy ucp-backup as a swarm service

Make sure to use the following constraint:
```node.role==manager```

Bind mount the Docker socket on:
```/var/run/docker.sock```

Expose the following two environment variables to your service:

``` AWS_REGION = <the_aws_region_your_s3_account_lives>```

``` AWS_BUCKET = <the_name_of_your_s3_bucket>```


