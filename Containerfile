FROM ubuntu:24.04

ENV HOME=/home/mtn-admin
ARG USER_ID=1000

# Copy helper scripts and make executable
COPY ./container/scripts /tmp/container-scripts
RUN chmod -R +x /tmp/container-scripts

# Install packages and tools via script
RUN /tmp/container-scripts/install-packages.sh

# Create user and workspace
RUN userdel -r ubuntu || true
RUN useradd -u ${USER_ID} -m -s /bin/bash mtn-admin \
  && echo "mtn-admin ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && chown -R mtn-admin:mtn-admin $HOME
RUN mkdir /opt/python-venv \
  && chown mtn-admin:mtn-admin /opt/python-venv

# Configure bash prompt and aliases via script
RUN /tmp/container-scripts/setup-shell.sh
ENV PATH="/opt/python-venv/bin:$PATH"

WORKDIR $HOME
USER mtn-admin

RUN /tmp/container-scripts/install-ansible.sh

HEALTHCHECK CMD [ "ls", "/" ]
