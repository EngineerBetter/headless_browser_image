FROM ubuntu:18.04

ENV LANG="C.UTF-8"

# install utilities
RUN apt-get update && apt-get install -y --no-install-recommends --fix-missing \
  wget \
  xvfb \
  unzip \
  dbus \
  dbus-x11 \
  git \
  gnupg2 \
  ca-certificates \
  build-essential \
  && rm -rf /var/lib/apt/lists/*

# install go
RUN wget -q https://golang.org/dl/go1.15.2.linux-amd64.tar.gz \
  && tar -xvf go1.15.2.linux-amd64.tar.gz \
  && mv go /usr/local \
  && rm -f go1.15.2.linux-amd64.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN go get github.com/onsi/ginkgo/ginkgo \
  github.com/onsi/gomega \
  github.com/sclevine/agouti

# install chrome
# Check available versions here: https://www.ubuntuupdates.org/package/google_chrome/stable/main/base/google-chrome-stable
ARG CHROME_VERSION="85.0.4183.102-1"
RUN wget --no-verbose -O /tmp/chrome.deb http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
  && apt-get install -y /tmp/chrome.deb \
  && rm /tmp/chrome.deb
RUN wget -N http://chromedriver.storage.googleapis.com/85.0.4183.87/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip \
  && chmod +x chromedriver \
  && mv -f chromedriver /usr/local/bin/chromedriver \
  && rm -f chromedriver_linux64.zip
