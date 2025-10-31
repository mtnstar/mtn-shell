FROM ubuntu:24.04

ENV HOME=/home/mtn-admin
ARG USER_ID=1000

RUN apt-get update && \
      apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg \
      neovim \
      git git-lfs \
      dnsutils mtr iputils-ping \
      bash-completion \
      ssh \
      sudo \
      lsb-release \
      python3 python3-pip python3-venv build-essential \
      && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
      && apt-get install -y --no-install-recommends nodejs \
      && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
      && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list \
      && apt-get update \
      && apt-get install -y --no-install-recommends docker-ce-cli \
      && npm install -g prettier

RUN userdel -r ubuntu || true
RUN useradd -u ${USER_ID} -m -s /bin/bash mtn-admin \
  && echo "mtn-admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN mkdir /opt/python-venv \
  && chown mtn-admin:mtn-admin /opt/python-venv

RUN echo "export PS1='[\e[0;33m]M[\e[0;34m]T[\e[0;33m]N[\e[0m] [\e[0;36m]\u:[\e[0;33m]\w[\e[0m]$ '" >> /etc/bash.bashrc
RUN echo "alias docker='sudo docker'" >> /etc/bash.bashrc

WORKDIR $HOME
USER mtn-admin

RUN python3 -m venv /opt/python-venv
ENV PATH="/opt/python-venv/bin:$PATH"
RUN pip install --no-cache-dir --upgrade pip==24.0 \
      molecule==25.7.0 \
      ansible==11.9.0 \
      pytest \ 
      testinfra \
      yamllint \
      molecule-plugins[docker]==25.8.12

HEALTHCHECK CMD [ "ls", "/" ]
