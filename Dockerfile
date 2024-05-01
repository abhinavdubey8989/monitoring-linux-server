
# This dockerfile is to build custom ubuntu img

# base image is ubuntu 
FROM ubuntu:22.04

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
    netcat \
    htop



# copy necessary scipts into the image
COPY send_load_avg.sh /
COPY put_load.sh /