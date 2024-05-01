
FROM ubuntu:22.04
# FROM jrei/systemd-ubuntu:22.04


# Update & intall packages 
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    iputils-ping \
    git \
    sysstat \
    build-essential \
    wget \
    libpcre3 \
    libpcre3-dev \
    zlib1g \
    zlib1g-dev \
    libssl-dev \
    vim \ 
    cron \
    netcat



# RUN rm -rf /etc/default/sysstat
# COPY sysstat /etc/default/sysstat

COPY send_load_avg_script.sh /

COPY add_load.sh /