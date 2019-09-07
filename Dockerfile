FROM ubuntu:latest

# Install utilities necessary for the installation of Docker and Node.js.
RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install Docker.
RUN curl -fLsS https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable" \
    && apt-get update && apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    && rm -rf /var/lib/apt/lists/*

# Install Docker Compose.
RUN curl -fLsS "https://github.com/docker/compose/releases/download/1.24.1/docker-compose-Linux-x86_64" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Install Node.js.
RUN curl -fLsS "https://deb.nodesource.com/setup_12.x" | sudo -E bash - \
    && sudo apt-get install -y nodejs

# Test the installations of Docker, Docker Compose and Node.js.
RUN docker-compose -v && node -v && npm -v