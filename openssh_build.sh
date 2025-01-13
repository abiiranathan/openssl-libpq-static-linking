#!/bin/bash

# Exit on error
set -e

# Configuration
OPENSSL_VERSION="3.4.0"
BUILD_DIR="$(pwd)/openssl_build"
INSTALL_DIR="$(pwd)/openssl_install"

# Required packages
sudo apt-get update
sudo apt-get install -y build-essential checkinstall zlib1g-dev perl

# Create and enter build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Download OpenSSL
wget "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz"
tar xzf "openssl-${OPENSSL_VERSION}.tar.gz"
cd "openssl-${OPENSSL_VERSION}"

# Configure OpenSSL build
# no-shared: Create static libraries only
# no-dso: Disable dynamic engine loading
# no-weak-ssl-ciphers: Exclude weak ciphers
./Configure linux-x86_64 no-shared no-dso no-weak-ssl-ciphers --prefix="$INSTALL_DIR" --openssldir="$INSTALL_DIR"

# Build and install
make -j$(nproc)
make install_sw

# Verify the build
"$INSTALL_DIR/bin/openssl" version

echo "OpenSSL static build completed successfully!"
echo "Binary location: $INSTALL_DIR/bin/openssl"
echo "Libraries location: $INSTALL_DIR/lib"
echo "Include files location: $INSTALL_DIR/include"
