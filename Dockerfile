FROM alpine:latest

MAINTAINER patrick.bleek@docker.com

RUN apk add --update curl && \
    rm -rf /var/cache/apk/*

RUN apk add --no-cache tzdata && \
    rm -rf /var/cache/apk/*

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --update docker && \
    rm -rf /var/cache/apk/*

RUN apk add --update py2-pip && \
    pip install awscli && \
    rm -rf /var/cache/apk/*

RUN mkdir /root/.aws

COPY ucp-backup.sh /root/

RUN echo "10 1 * * *	/root/ucp-backup.sh" >>/etc/crontabs/root

CMD ["/usr/sbin/crond","-c","/etc/crontabs","-f"]
