FROM ubuntu:16.04
MAINTAINER kelvin.beats@gmail.com
WORKDIR /tmp
RUN apt-get update
RUN apt-get install -y curl apt-utils xvfb wget default-jre vim git
RUN apt-get install -y locales

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment; \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen; \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf; \
    locale-gen en_US.UTF-8;

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y --allow-unauthenticated nodejs
RUN apt-get install -y build-essential

RUN npm install -g n
RUN n 7.1.0
RUN npm install -g protractor bower mocha jasmine grunt-cli puppeteer gulp@latest
RUN webdriver-manager update
## RUN curl -k https://install.meteor.com/?release=1.5.2.2 | sh

## Install chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update
RUN apt-get install -y google-chrome-stable

## Clean up
RUN apt-get clean

ADD addUser.sh /addUser.sh

RUN /addUser.sh

RUN su testerguy -c "echo 'Installing meteor:'; curl -k https://install.meteor.com/?release=1.5.2.2 | sh"
RUN mkdir /protractor
ENV SCREEN_RES=1280x1024x24

ADD protractor.sh /protractor.sh
ADD runtests.sh /runtests.sh

RUN echo y | apt-get install -y sudo

WORKDIR /protractor
ENTRYPOINT ["/runtests.sh"]
