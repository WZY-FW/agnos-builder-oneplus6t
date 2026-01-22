#!/bin/bash -e

echo "Installing python for openpilot"

# Install necessary dependencies for Python compilation
echo "Installing Python dependencies..."
apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libncurses5-dev \
    libsqlite3-dev \
    libreadline-dev \
    libtk8.6 \
    libgdm-dev \
    libdb4o-cil-dev \
    libpcap-dev \
    libbz2-dev \
    liblzma-dev \
    zlib1g-dev \
    libffi-dev \
    wget \
    curl \
    git

# Install pyenv
export PYENV_ROOT="/usr/local/pyenv"
curl https://pyenv.run | bash
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

PYTHON_VERSION="3.8.10"
if [ "$(uname -p)" == "aarch64" ]; then
  pyenv install --verbose $PYTHON_VERSION
else
  MAKEFLAGS="-j1" MAKE_OPTS="-j1" taskset --cpu-list 0 pyenv install --verbose $PYTHON_VERSION
fi

echo "Setting global python version"
pyenv global $PYTHON_VERSION
