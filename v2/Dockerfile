FROM geerlingguy/docker-debian13-ansible:latest

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server nftables \
    && systemctl enable ssh nftables \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /root/.ssh
COPY authorized_keys /root/.ssh/authorized_keys
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/authorized_keys

# Hardened base: default-deny inbound firewall, applied at boot.
# Only SSH (management) is permitted; application ports such as HTTP/80
# must be opened explicitly. This is what the to-vm behaviour test catches.
COPY v2/nftables.conf /etc/nftables.conf
