# https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

FROM docker.io/ubuntu:22.04  as base

ARG DEBIAN_FRONTEND=noninteractive

SHELL [ "/bin/bash", "-c" ]

WORKDIR /tmp/

## INSTALL APPS
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    curl \
    git \
    gnupg \
    gpg \
    ssh \
    sshpass \
    sudo \
    tzdata \
    vim \
    wget \
    wslu \
&&  apt-get clean \
&&  rm -rf /var/lib/apt/lists/*

FROM base as docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh \ 
&&  sed -i '/( set -x; sleep 20 )/d' ./get-docker.sh \
&&  chmod u+x ./get-docker.sh \
&&  ./get-docker.sh 

FROM docker as wsl2

COPY ./scripts/wsl.conf /etc/wsl.conf
# The following copy is needed for systemd and windows interopability
COPY ./scripts/WSLInterop.conf /usr/lib/binfmt.d/WSLInterop.conf
COPY ./scripts/wslhome /usr/local/bin/
RUN fc-cache -fv \
&&  systemctl enable docker.service \
&&  systemctl enable containerd.service \
&&  chmod 755 /usr/local/bin/wslhome \
&&  useradd -m -d /home/developer -s /bin/bash -g docker -G sudo -u 1000 developer \
&&  echo "developer:developer" | chpasswd \
&&  echo 'developer ALL=(ALL) NOPASSWD:ALL' | tee -a /etc/sudoers 
COPY ./scripts/.bash_aliases /home/developer/
RUN  chown developer.docker /home/developer/.bash_aliases
USER developer
WORKDIR /home/developer


ARG DEBIAN_FRONTEND=