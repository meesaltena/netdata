#!/usr/bin/env sh
#
# Installation script for the alpine host
# to prepare the static binary
#
# Copyright: SPDX-License-Identifier: GPL-3.0-or-later
#
# Author: Paul Emm. Katsoulakis <paul@netdata.cloud>

# Add required APK packages
apk add --no-cache -U \
  bash \
  wget \
  curl \
  ncurses \
  git \
  netcat-openbsd \
  alpine-sdk \
  autoconf \
  automake \
  gcc \
  make \
  cmake \
  libtool \
  pkgconfig \
  util-linux-dev \
  openssl-dev \
  gnutls-dev \
  zlib-dev \
  libmnl-dev \
  libnetfilter_acct-dev \
  libuv-dev \
  lz4-dev \
  openssl-dev \
  snappy-dev \
  protobuf-dev \
  binutils \
  gzip \
  xz || exit 1

# snappy doesnt have static version in alpine, let's compile it
export SNAPPY_VER="1.1.7"
wget -O /snappy.tar.gz https://github.com/google/snappy/archive/${SNAPPY_VER}.tar.gz
tar -C / -xf /snappy.tar.gz
rm /snappy.tar.gz
cd /snappy-${SNAPPY_VER} || exit 1
mkdir build
cd build || exit 1
cmake -DCMAKE_BUILD_SHARED_LIBS=true -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_INSTALL_LIBDIR=lib ../
make && make install

# Judy doesnt seem to be available on the repositories, download manually and install it
export JUDY_VER="1.0.5"
wget -O /judy.tar.gz http://downloads.sourceforge.net/project/judy/judy/Judy-${JUDY_VER}/Judy-${JUDY_VER}.tar.gz
tar -C / -xf /judy.tar.gz
rm /judy.tar.gz
cd /judy-${JUDY_VER} || exit 1
CFLAGS="-O2 -s" CXXFLAGS="-O2 -s" ./configure
make
make install
