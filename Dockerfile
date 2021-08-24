# Dockerfile for Filebeat

# Build with:
# docker build -t "filebeat" .

# Alpine OS 3.4
# http://dl-cdn.alpinelinux.org/alpine/v3.4/community/x86_64/
FROM alpine:3.4

MAINTAINER Tuan Vo <vohungtuan@gmail.com>

###############################################################################
#                                INSTALLATION
###############################################################################

ENV FILEBEAT_VERSION=7.14.0

RUN   apk update \
 &&   apk add ca-certificates wget \
 &&   update-ca-certificates

RUN set -x \
 && apk add --update bash \
                     curl \
                     tar \
                                         openssl \
 && curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
 && tar xzvf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -C / --strip-components=1 \
 && rm -rf filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz \
 && apk --no-cache add ca-certificates \
 && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.34-r0/glibc-2.34-r0.apk \
 && apk add glibc-2.34-r0.apk \
 && apk del curl \
            tar \
                        openssl \
 && rm -rf /var/cache/apk/*

###############################################################################
#                                   START
###############################################################################

COPY docker-entrypoint.sh /
RUN chmod +x docker-entrypoint.sh filebeat \
 && ln -s /filebeat /bin/filebeat

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD []
