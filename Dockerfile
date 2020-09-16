FROM golang:latest as go

RUN go get github.com/onsi/ginkgo/ginkgo \
  github.com/onsi/gomega \
  github.com/sclevine/agouti

FROM ubuntu:18.04

COPY --from=go /go/bin/ /usr/bin/

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
  && rm -rf /var/lib/apt/lists/*

# install chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update && apt-get install -y --no-install-recommends \
  google-chrome-stable
RUN wget -N http://chromedriver.storage.googleapis.com/86.0.4240.22/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip \
  && chmod +x chromedriver \
  && mv -f chromedriver /usr/local/bin/chromedriver
