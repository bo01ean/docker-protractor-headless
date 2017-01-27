FROM ubuntu:16.04
MAINTAINER kelvin.beats@gmail.com
WORKDIR /tmp
RUN apt-get update
RUN apt-get install -y curl apt-utils xvfb wget default-jre vim
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install -y nodejs
##RUN npm install -g npm@3.10.7
RUN curl -L https://www.npmjs.com/install.sh | sh
RUN npm install -g protractor bower mocha jasmine n
RUN n 6.3.1
RUN webdriver-manager update
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update
RUN apt-get install -y google-chrome-stable
RUN apt-get clean

ADD addUser.sh /addUser.sh
RUN /addUser.sh
#RUN rm google-chrome-stable_current_amd64.deb
RUN mkdir /protractor

RUN webdriver-manager update
ADD protractor.sh /protractor.sh
ADD runtests.sh /runtests.sh
# Fix for the issue with Selenium, as described here:
# https://github.com/SeleniumHQ/docker-selenium/issues/87
# ENV DBUS_SESSION_BUS_ADDRESS=/dev/null
ENV SCREEN_RES=1280x1024x24
WORKDIR /protractor
ENTRYPOINT ["/runtests.sh"]
