
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
    vim \ 
    cron \
    netcat \
    htop \
    net-tools



# The "-p" option is used with the mkdir command to create parent directories as needed
# It ensures that if the parent directories of /my_directory do not exist, they will be created as well
RUN mkdir -p /monitoring_scripts
COPY monitoring_scripts /monitoring_scripts

# make the scripts executable
RUN chmod +x /monitoring_scripts/*.sh
