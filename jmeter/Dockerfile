# Use alpine linux as base image
FROM alpine:latest as BASE

# Install openjre (required in order to run jmeter)
RUN apk add openjdk8-jre bash

# Set work directory to be /jmeter
WORKDIR /jmeter

# Install jmeter
ARG JMETER_VERSION
ENV JMETER_VERSION ${JMETER_VERSION}
ENV JMETER_HOME /jmeter/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN ${JMETER_HOME}/bin

RUN apk add tzdata && \
  cp /usr/share/zoneinfo/Europe/Vienna /etc/localtime && \
  echo "Europe/Vienna" >  /etc/timezone && \
  apk del tzdata

RUN echo "version=${JMETER_VERSION}" && \
  wget -q -O /jmeter/apache-jmeter.tgz "https://www-eu.apache.org/dist//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz" && \
  tar xzf apache-jmeter.tgz && \
  rm /jmeter/apache-jmeter.tgz



FROM BASE

# Copy contents of current directory to /jmeter
COPY entrypoint.sh  /jmeter/run
COPY bashrc         /jmeter/.bashrc

RUN adduser -D -h /jmeter -u 1001 jmeter && \
  chown -R jmeter /jmeter && \
  chmod +x /jmeter/run

# Make entrypoint.sh executable
# RUN mkdir /data &&  chown jmeter /data

USER jmeter

# Edit jmeter.properties, point to correct user.properties
RUN sed -i -e "s|user.properties=user.properties|user.properties=/data/user.properties|g;" \
  ${JMETER_BIN}/jmeter.properties

ENV HEAP "-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m"

# Execute entrypoint.sh
CMD /bin/sh /jmeter/run tail notest
