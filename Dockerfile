FROM  golang:alpine

RUN apk add --no-cache \
    curl \
    git \
    jq \
    busybox-extras \
    bash \
    openssh-client \
  && go get github.com/adnanh/webhook \
  && go get github.com/digitalocean/doctl/cmd/doctl

EXPOSE 9000
ENTRYPOINT ["/go/bin/webhook"]
