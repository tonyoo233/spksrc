FROM debian:buster
MAINTAINER SynoCommunity <https://synocommunity.com>

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Install required packages (in sync with README.rst instructions
RUN apt-get update && apt-get install --no-install-recommends -y \
        autogen \
        automake \
        bc \
        bison \
        build-essential \
        check \
        cmake \
        curl \
        cython \
        debootstrap \
        expect \
        flex \
        g++-multilib \
        gettext \
        git \
        gperf \
        imagemagick \
        intltool \
        libbz2-dev \
        libc6-i386 \
        libcppunit-dev \
        libffi-dev \
        libgc-dev \
        libgmp3-dev \
        libltdl-dev \
        libmount-dev \
        libncurses-dev \
        libpcre3-dev \
        libssl-dev \
        libtool \
        libunistring-dev \
        lzip \
        mercurial \
        ncurses-dev \
        php \
        pkg-config \
        pgp \
        python3 \
        python3-distutils \
        scons \
        subversion \
        swig \
        unzip \
        yarn \
        xmlto \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# install dotnet
RUN wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget https://packages.microsoft.com/config/debian/10/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    apt-get update && apt-get install --no-install-recommends -y \
        dotnet-sdk-3.1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Install setuptools, wheel and pip for Python3
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python3

# Install setuptools, pip, virtualenv, wheel and httpie for Python2
RUN wget https://bootstrap.pypa.io/get-pip.py -O - | python
RUN pip install virtualenv httpie

# Volume pointing to spksrc sources
VOLUME /spksrc

WORKDIR /spksrc
