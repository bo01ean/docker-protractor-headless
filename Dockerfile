FROM node:6.9.4-slim
MAINTAINER j.ciolek@webnicer.com
WORKDIR /tmp
ADD google-chrome-stable_54.0.2840.71-1_amd64.deb /tmp/
RUN npm install -g protractor@4.0.14 mocha jasmine && \
    webdriver-manager update --versions.chrome 2.7 && \
    apt-get update && \
    apt-get install -y xvfb wget openjdk-7-jre && \
    dpkg --unpack /tmp/google-chrome-stable_54.0.2840.71-1_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_54.0.2840.71-1_amd64.deb && \
    mkdir /protractor
ADD protractor.sh /protractor.sh
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
WORKDIR /protractor
ENTRYPOINT ["/protractor.sh"]
