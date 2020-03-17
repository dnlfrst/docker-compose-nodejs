ARG UBUNTU_VERSION="18.04"

FROM ubuntu:${UBUNTU_VERSION}

ARG CONTAINERD_VERSION="1.2.13-1"
ARG DOCKER_VERSION="5:19.03.8~3-0"
ARG DOCKER_COMPOSE_VERSION="1.25.4"
ARG NODEJS_VERSION="12.16.1"

# Install utilities necessary for the following installations
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -fLsS https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu/ \
     $(lsb_release -cs) stable" \
    && apt-get update && apt-get install -y \
    docker-ce=${DOCKER_VERSION}~ubuntu-$(lsb_release -cs) \
    docker-ce-cli=${DOCKER_VERSION}~ubuntu-$(lsb_release -cs) \
    && rm -rf /var/lib/apt/lists/*

# Install Docker Compose
RUN curl -fLsS "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Install Node.js
RUN curl -fLsS "https://deb.nodesource.com/setup_12.x" | sudo -E bash - \
    && sudo apt-get install -y nodejs \
    && npm i -g n \
    && n ${NODEJS_VERSION}

# Test the installations of Docker, Docker Compose and Node.js
RUN docker-compose -v && node -v && npm -v