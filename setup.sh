#!/bin/sh
# Adds the Sc apps apt repository to Ubuntu / Zorin OS.
# Usage: curl -fsSL https://sontosbit.github.io/sc-apt/setup.sh | sudo sh
set -e

URL=https://sontosbit.github.io/sc-apt

if [ "$(id -u)" != 0 ]; then
    echo "Please run with sudo: curl -fsSL $URL/setup.sh | sudo sh" >&2
    exit 1
fi

if command -v curl >/dev/null; then
    curl -fsSL "$URL/sc-apt.gpg" -o /usr/share/keyrings/sc-apt.gpg
else
    wget -qO /usr/share/keyrings/sc-apt.gpg "$URL/sc-apt.gpg"
fi
chmod 644 /usr/share/keyrings/sc-apt.gpg

cat > /etc/apt/sources.list.d/sc-apt.sources <<EOF
Types: deb
URIs: $URL
Suites: stable
Components: main
Signed-By: /usr/share/keyrings/sc-apt.gpg
EOF

apt-get update -o Dir::Etc::sourcelist=/etc/apt/sources.list.d/sc-apt.sources \
    -o Dir::Etc::sourceparts=- -o APT::Get::List-Cleanup=0

echo
echo "Done. Install with:  sudo apt install sc-panel"
