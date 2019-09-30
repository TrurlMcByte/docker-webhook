FROM golang:alpine AS builder

ARG TARGETOS=linux
ARG TARGETARCH=amd64

ENV CGO_ENABLED=0 \
    GOOS=$TARGETOS \
    GOARCH=$TARGETARCH

RUN apk add --no-cache git \
 && echo "Build: GOOS=${GOOS} GOARCH=${GOARCH}" \
 && go get -ldflags="-w -s" github.com/adnanh/webhook \
 && go get -ldflags="-w -s" github.com/digitalocean/doctl/cmd/doctl


FROM alpine:latest

RUN apk add --no-cache \
    curl \
    git \
    jq \
    busybox-extras \
    bash \
    file \
    openssh-client \
  && KUBERNETES_VERSION=`curl -sL https://storage.googleapis.com/kubernetes-release/release/stable.txt` \
  && curl -sfLO https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64/kubectl  \
  && chmod +x ./kubectl \
  && mv ./kubectl /bin/kubectl

COPY --from=builder /go/bin/* /go/bin/

EXPOSE 9000
ENTRYPOINT ["/go/bin/webhook"]
