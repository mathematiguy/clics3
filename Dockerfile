FROM ubuntu:18.04

# Use New Zealand mirrors
RUN sed -i 's/archive/nz.archive/' /etc/apt/sources.list

RUN apt update

# Set timezone to Auckland
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y locales tzdata
RUN locale-gen en_NZ.UTF-8
RUN dpkg-reconfigure locales
RUN echo "Pacific/Auckland" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata
ENV LANG en_NZ.UTF-8
ENV LANGUAGE en_NZ:en

# Install python + other things
RUN apt install -y python3-dev python3-pip git wget build-essential python-dev libxml2 libxml2-dev zlib1g-dev
COPY requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt

COPY datasets.txt /root/datasets.txt
RUN pip3 install -r /root/datasets.txt

# Add non-root user
RUN useradd -ms /bin/bash clics
USER clics

WORKDIR /home/clics
COPY submodules /home/clics/submodules
COPY .config /home/clics/.config
