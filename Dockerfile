FROM alpine:latest

ENV GOPATH=/go \
    SRCPATH=${GOPATH}/src/github.com/adnanh \
    WEBHOOK_VERSION=2.4.0

RUN apk add --no-cache \
    curl \
    git \
    openssh-client \
  && apk add --no-cache -t build-deps \
    gcc \
    go \
    libc-dev \
    libgcc \
  && curl -L -o /tmp/webhook-${WEBHOOK_VERSION}.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz \
  && mkdir -p ${SRCPATH} \
  && tar -xvzf /tmp/webhook-${WEBHOOK_VERSION}.tar.gz -C ${SRCPATH} \
  && mv -f ${SRCPATH}/webhook-* ${SRCPATH}/webhook \
  && cd ${SRCPATH}/webhook \
  && go get -d \
  && go build -o /usr/local/bin/webhook \
  && apk del --purge build-deps \
  && rm -rf ${GOPATH}

#  && rm -rf /var/cache/apk/* \

EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/webhook"]
