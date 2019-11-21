#### FROM ppc64le/golang:1.13-alpine as BUILDER
FROM golang:1.13-alpine as BUILDER

WORKDIR /go/src/github.com/influxdata/influxdb

ARG INFLUXDB_VERSION
ENV INFLUXDB_VERSION ${INFLUXDB_VERSION}

# RUN  apk add --no-cache --virtual .build-deps wget gnupg tar git   && \
RUN  apk add --no-cache --virtual wget gnupg tar git   && \
  go get -u github.com/golang/dep/... && \
  git clone https://github.com/influxdata/influxdb.git . && \
  git config --global advice.detachedHead false && \
  git checkout v${INFLUXDB_VERSION} && \
  dep ensure -vendor-only && \
  go install ./cmd/...


# fetch entrypoint.sh script etc from Official Docker Image Build repo
WORKDIR /go/src/github.com/influxdata/influxdata-docker
RUN git clone https://github.com/influxdata/influxdata-docker.git .


# --------------------------------------------------------------------------------------------------------
# based on the "Offical Docker Image Build" obtained from:
#   https://raw.githubusercontent.com/influxdata/influxdata-docker/master/influxdb/1.7/alpine/Dockerfile

#### FROM ppc64le/alpine:3.9
FROM alpine:3.9

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf
RUN apk add --no-cache tzdata bash ca-certificates && \
  update-ca-certificates

# ENV INFLUXDB_VERSION 1.7.9
# RUN set -ex && \
#   apk add --no-cache --virtual .build-deps wget gnupg tar && \
#   for key in \
#   05CE15085FC09D18E99EFB22684A14CF2582E0C5 ; \
#   do \
#   gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key" || \
#   gpg --keyserver pgp.mit.edu --recv-keys "$key" || \
#   gpg --keyserver keyserver.pgp.com --recv-keys "$key" ; \
#   done && \
#   wget --no-verbose https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc && \
#   wget --no-verbose https://dl.influxdata.com/influxdb/releases/influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
#   gpg --batch --verify influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz.asc influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
#   mkdir -p /usr/src && \
#   tar -C /usr/src -xzf influxdb-${INFLUXDB_VERSION}-static_linux_amd64.tar.gz && \
#   rm -f /usr/src/influxdb-*/influxdb.conf && \
#   chmod +x /usr/src/influxdb-*/* && \
#   cp -a /usr/src/influxdb-*/* /usr/bin/ && \
#   rm -rf *.tar.gz* /usr/src /root/.gnupg && \
#   apk del .build-deps
# COPY influxdb.conf /etc/influxdb/influxdb.conf

COPY --from=BUILDER /go/bin/* /usr/bin/
COPY --from=BUILDER /go/src/github.com/influxdata/influxdb/etc/config.sample.toml /etc/influxdb/influxdb.conf

EXPOSE 8086

VOLUME /var/lib/influxdb

# COPY entrypoint.sh /entrypoint.sh
COPY --from=BUILDER /go/src/github.com/influxdata/influxdata-docker/influxdb/1.7/alpine/entrypoint.sh /entrypoint.sh
# COPY init-influxdb.sh /init-influxdb.sh
COPY --from=BUILDER /go/src/github.com/influxdata/influxdata-docker/influxdb/1.7/alpine/init-influxdb.sh /init-influxdb.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["influxd"]
