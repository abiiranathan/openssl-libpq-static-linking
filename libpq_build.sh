#!/bin/bash

# Exit on error
set -e

# Configuration
PG_VERSION="16.2"
BUILD_DIR="$(pwd)/postgresql_build"
INSTALL_DIR="$(pwd)/postgresql_install"
OPENSSL_INSTALL="$(pwd)/openssl_install"

# Required packages
sudo apt-get update -y
sudo apt-get install -y build-essential wget tar zlib1g-dev bison flex pkg-config

# Create and enter build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Download PostgreSQL source
wget "https://ftp.postgresql.org/pub/source/v${PG_VERSION}/postgresql-${PG_VERSION}.tar.gz"
tar xzf "postgresql-${PG_VERSION}.tar.gz"
cd "postgresql-${PG_VERSION}"

# Configure PostgreSQL build
./configure \
    --prefix="$INSTALL_DIR" \
    --without-readline \
    --without-zlib \
    --with-ssl=static \
    --with-openssl \
    --with-includes="$OPENSSL_INSTALL/include" \
    --with-libraries="$OPENSSL_INSTALL/lib" \
    --without-ldap \
    --without-systemd \
    --without-pam \
    --without-perl \
    --without-python \
    --without-tcl \
    --without-icu \
    --without-lz4 \
    --without-zstd

# Build only libpq and required components
cd src/interfaces
make -j$(nproc) all

# Install libpq and headers
mkdir -p "$INSTALL_DIR/lib"
mkdir -p "$INSTALL_DIR/include"

make install

cp $BUILD_DIR/postgresql-$PG_VERSION/src/include/*.h $INSTALL_DIR/include
cp $BUILD_DIR/postgresql-$PG_VERSION/src/common/libpgcommon.a $INSTALL_DIR/lib
cp $BUILD_DIR/postgresql-$PG_VERSION/src/port/libpgport.a $INSTALL_DIR/lib

echo "LibPQ static build completed successfully!"
