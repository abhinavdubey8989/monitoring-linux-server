# Dockerfile for Kubernetes worker node
FROM ubuntu:22.04

# Update package lists
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    iputils-ping \
    git 

RUN apt-get install -y build-essential wget libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev vim && \
    apt-get clean


