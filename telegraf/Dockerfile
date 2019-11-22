FROM ppc64le/golang:1.13-alpine as BUILDER
# FROM golang:1.13-alpine as BUILDER


ARG TELEGRAF_VERSION
ENV TELEGRAF_VERSION ${TELEGRAF_VERSION}

RUN  apk add --no-cache wget gnupg tar git make gcc 

WORKDIR /go/src/github.com/influxdata/telegraf

ENV CGO_ENABLED=0

RUN  go get -u github.com/golang/dep/...  && \
  git clone https://github.com/influxdata/telegraf.git . && \
  git config --global advice.detachedHead false && \
  git checkout ${TELEGRAF_VERSION}

RUN make clean && \
  make && \
  make install && \
  make go-install


# fetch entrypoint.sh script etc from Official Docker Image Build repo
WORKDIR /go/src/github.com/influxdata/influxdata-docker

RUN git clone https://github.com/influxdata/influxdata-docker.git .


# --------------------------------------------------------------------------------------------------------
# based on the "Offical Docker Image Build" obtained from:
#   https://raw.githubusercontent.com/influxdata/influxdata-docker/master/telegraf/1.12/alpine/Dockerfile

FROM ppc64le/alpine:3.9
# FROM alpine:3.9

RUN echo 'hosts: files dns' >> /etc/nsswitch.conf && \
  apk add --no-cache iputils ca-certificates net-snmp-tools procps lm_sensors tzdata && \
  update-ca-certificates

ENV TELEGRAF_VERSION 1.12.6

EXPOSE 8125/udp 8092/udp 8094

COPY --from=BUILDER /go/bin/* /usr/bin/
COPY --from=BUILDER /go/src/github.com/influxdata/telegraf/etc/telegraf.conf /etc/telegraf/telegraf.conf
COPY --from=BUILDER /go/src/github.com/influxdata/influxdata-docker/telegraf/1.12/alpine/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["telegraf"]
