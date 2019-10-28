ARG NODE_VERSION=10
FROM node:${NODE_VERSION}-stretch

RUN apt-get update \
    && apt-get install -y python3-pip libssl-dev build-essential \
    libffi-dev python3-dev docker nano vim telnet mc \
    apt-transport-https ca-certificates curl gnupg-agent software-properties-common \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    xenial \
    stable" \
    &&  apt-get update && apt install -y docker-ce=17.12.0~ce-0~ubuntu \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN pip3 install \
    ansible==2.8.2 \
    apache-libcloud==1.3.0 \
    boto molecule pycrypto python-vagrant \
    cryptography==2.6.1 \
    docker==4.0.1 

COPY weakref.py /usr/lib/python3.5/weakref.py

ARG version=latest

WORKDIR /home/theia
ADD $version.package.json ./package.json
ARG GITHUB_TOKEN
RUN yarn --cache-folder ./ycache && rm -rf ./ycache
RUN yarn theia build
EXPOSE 3000
ENV LANG C.UTF-8
ENV SHELL /bin/bash
ENTRYPOINT [ "yarn", "theia", "start", "/home/project", "--hostname=0.0.0.0" ]
