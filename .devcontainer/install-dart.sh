#!/bin/bash
set -e

sudo apt update && sudo apt install -y apt-transport-https
sudo sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/dart-archive-keyring.gpg'
sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/dart-archive-keyring.gpg] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main" > /etc/apt/sources.list.d/dart_stable.list'

sudo apt update && sudo apt install -y dart
echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.bashrc
