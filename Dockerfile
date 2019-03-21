FROM alpine

RUN apk add --update --no-cache sshpass openssh && \
  rm -rf /tmp/* /var/cache/apk/* && \
  adduser -D user && \
  passwd -u user