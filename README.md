# Docker image of Protractor with headless Chrome

Protractor end to end testing for AngularJS - dockerised with headless real Chrome.

## Why headless Chrome?

PhantomJS is [discouraged by Protractor creators](https://angular.github.io/protractor/#/browser-setup#setting-up-phantomjs) and for a good reason. It's basically a bag of problems.

## What is headless Chrome anyway?

To be perfectly honest - it is a [real chrome running on xvfb](http://tobyho.com/2015/01/09/headless-browser-testing-xvfb/). Therefore you have every confidence that the tests are run on the real thing.

# Build latest headless-horseman

```bash

git clone https://github.com/bo01ean/docker-protractor-headless headless-horseman
cd headless-horseman
docker build . -t headless-horseman

```

# Create 'test-headless' npm task in package.json

### *put /protractor.sh where you would normally call protractor*

```json

{
  "test": "ENVIRONMENT=dev protractor.sh e2e-tests/protractor.conf.js", // normally
  "test-headless": "ENVIRONMENT=dev /protractor.sh e2e-tests/protractor.conf.js", // headless-horseman
}

```

# Run headless-horseman on your code

## From macOS:
```bash

cd - ## Assumes you were in your webapp before
docker run --privileged --net=host -it -v `pwd`:/protractor headless-horseman

```

## From Linux host:
```bash

cd - ## Assumes you were in your webapp before
docker run --privileged --net=host -it -v `pwd`:/protractor -v /dev/shm:/dev/shm headless-horseman

```

## Setting up custom screen resolution
The default screen resolution is **1280x1024** with **24-bit color**. You can set a custom screen resolution and color depth via the **SCREEN_RES** env variable, like this:
```bash

docker run -it --privileged --rm --net=host -e SCREEN_RES=1920x1080x24 -v /dev/shm:/dev/shm -v $(pwd):/protractor headless-horseman

```


## Why mapping `/dev/shm`?

Docker has hardcoded value of 64MB for `/dev/shm`. Because of that you can encounter an error [session deleted becasue of page crash](https://bugs.chromium.org/p/chromedriver/issues/detail?id=1097) on memory intensive pages. The easiest way to mitigate that problem is share `/dev/shm` with the host.

This needs to be done till `docker build` [gets the option `--shm-size`](https://github.com/docker/docker/issues/2606).

## Why `--privileged`?

Chrome uses sandboxing, therefore if you try and run Chrome within a non-privileged container you will receive the following message:

"Failed to move to new namespace: PID namespaces supported, Network namespace supported, but failed: errno = Operation not permitted".

The [`--privileged`](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities) flag gives the container almost the same privileges to the host machine resources as other processes running outside the container, which is required for the sandboxing to run smoothly.

## Why `--net=host`?

This options is required **only** if the dockerised Protractor is run against localhost on the host. Imagine this sscenario: you run an http test server on your local machine, let's say on port 8000. You type in your browser `http://localhost:8000` and everything goes smoothly. Then you want to run the dockerised Protractor against the same localhost:8000. If you don't use `--net=host` the container will receive the bridged interface and its own loopback and so the `localhost` within the container will refer to the container itself. Using `--net=host` you allow the container to share host's network stack and properly refer to the host when Protractor is run against `localhost`.
