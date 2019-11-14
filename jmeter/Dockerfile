# Use alpine linux as base image
FROM alpine:latest as BASE

# Install openjre (required in order to run jmeter) 
RUN apk add openjdk8-jre

# Set work directory to be /jmeter
WORKDIR /jmeter

# Install jmeter
ARG JMETER_VERSION
ENV JMETER_VERSION ${JMETER_VERSION} 
ENV JMETER_HOME /jmeter/apache-jmeter-${JMETER_VERSION}
ENV JMETER_BIN ${JMETER_HOME}/bin
RUN echo "version=${JMETER_VERSION}" && \
    wget -q -O /jmeter/apache-jmeter.tgz "https://www-eu.apache.org/dist//jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz" && \
    tar xzf apache-jmeter.tgz && \
    rm /jmeter/apache-jmeter.tgz



FROM BASE 

# Copy contents of current directory to /jmeter
COPY test           /jmeter/test/
COPY entrypoint.sh  /jmeter/

RUN adduser -D -h /jmeter -u 10123 runner && \
    chown -R runner /jmeter

USER runner

# Make entrypoint.sh executable
RUN chmod +x ./entrypoint.sh

# Edit jmeter.properties, point to correct user.properties
ENV TESTDIR /jmeter/test
RUN sed -i -e "s|user.properties=user.properties|user.properties=${TESTDIR}/user.properties|g;" \
	    ${JMETER_BIN}/jmeter.properties

ENV HEAP "-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m"

# Execute entrypoint.sh
CMD /bin/sh /jmeter/entrypoint.sh
