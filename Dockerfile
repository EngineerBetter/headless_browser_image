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
  oathtool \
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
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update && apt-get install -y --no-install-recommends \
  google-chrome-stable
RUN wget -N http://chromedriver.storage.googleapis.com/85.0.4183.87/chromedriver_linux64.zip \
  && unzip chromedriver_linux64.zip \
  && chmod +x chromedriver \
  && mv -f chromedriver /usr/local/bin/chromedriver \
  && rm -f chromedriver_linux64.zip
