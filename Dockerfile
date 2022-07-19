FROM alpine/ansible:latest
RUN apk add --no-cache curl git
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]