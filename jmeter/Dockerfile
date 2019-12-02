# Use alpine linux as base image
FROM alpine:latest as BASE

# Install openjre (required in order to run jmeter)
RUN apk add openjdk8-jre bash

# Set work directory to be /jmeter
WORKDIR /jmeter

# Install jmeter
ARG JMETER_VERSION
ENV JMETER_VERSION ${JMETER_VERSION}
# ENV JMETER_HOME /jmeter/apache-jmeter-${JMETER_VERSION}
# ENV JMETER_BIN ${JMETER_HOME}/bin
ENV JMETER_HOME /jmeter
ENV JMETER_BIN ${JMETER_HOME}/bin

RUN apk add tzdata && \
  cp /usr/share/zoneinfo/Europe/Vienna /etc/localtime && \
  echo "Europe/Vienna" >  /etc/timezone && \
  apk del tzdata

RUN echo "version=${JMETER_VERSION}" && \
  wget -q -O /jmeter/apache-jmeter.tgz "https://www-eu.apache.org/dist//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz" && \
  tar -xzf apache-jmeter.tgz --strip-components=1 && \
  rm /jmeter/apache-jmeter.tgz

# add concurrent Thread Group v2.9 and some other plugins
ADD https://jmeter-plugins.org/files/packages/jpgc-casutg-2.9.zip https://jmeter-plugins.org/files/packages/jpgc-cmd-2.2.zip  /jmeter/
RUN unzip -o jpgc-casutg-2.9.zip && unzip -o jpgc-cmd-2.2.zip

FROM BASE

VOLUME /data

# Copy contents of current directory to /jmeter
COPY run              /jmeter/run
COPY bashrc           /jmeter/.bashrc
# found no way to automatically create the RMI server certificate without user interaction.
# thus we are using a prepared one: cn=rmi, validity=700 days
COPY rmi_keystore.jks   $JMETER_BIN/rmi_keystore.jks

RUN adduser -D -h /jmeter -u 1001 jmeter && \
  chown -R jmeter /jmeter  /data   && \
  chmod +x /jmeter/run && \
  ln -s /jmeter/run /jmeter/entrypoint.sh && \
  ln -s /jmeter/run /jmeter/runlocal

USER jmeter

# Edit jmeter.properties, point to correct user.properties
RUN sed -i -e "s|user.properties=user.properties|user.properties=/data/user.properties|g;" \
  ${JMETER_BIN}/jmeter.properties

# edit user.properties to specify the absolute RMI key-/truststore location!
# RUN sed -i \
#   -e "s|^#\?server.rmi.ssl.truststore.file=.*|server.rmi.ssl.truststore.file=${JMETER_BIN}/rmi_keystore.jks|g;" \
#   -e "s|^#\?server.rmi.ssl.keystore.file=.*|server.rmi.ssl.keystore.file=${JMETER_BIN}/rmi_keystore.jks|g;" \
#   -e "s|^#\?server.rmi.ssl.disable=.*|server.rmi.ssl.disable=false|g;" \
#   ${JMETER_BIN}/user.properties

ENV HEAP "-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m"

ENV JMETER_PLAN=no-plan-defined
ENV JMETER_ROLE=undefined
ENV JMETER_SLAVE_LIST=undefined

# Execute run
CMD /jmeter/entrypoint.sh
