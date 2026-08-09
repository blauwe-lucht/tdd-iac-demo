FROM geerlingguy/docker-debian13-ansible:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server \
    && systemctl enable ssh \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys
