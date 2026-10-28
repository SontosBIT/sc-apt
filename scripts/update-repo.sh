#!/bin/sh
# Rebuilds and signs the apt index after adding .deb files to pool/main/.
# Usage: scripts/update-repo.sh      (then commit and push)
# Needs the "Sc apps APT repository" GPG key on this computer.
set -e

KEY=AE97BFD044F4390F30F3031E79B3BFD1E311F83C
cd "$(dirname "$0")/.."

for arch in amd64 all; do
    dir=dists/stable/main/binary-$arch
    mkdir -p "$dir"
    # Architecture "all" packages are listed for amd64 too, so apt finds them there.
    apt-ftparchive --arch "$arch" packages pool/main > "$dir/Packages"
    gzip -9 -n -k -f "$dir/Packages"
done

apt-ftparchive \
    -o APT::FTPArchive::Release::Origin="Sc apps" \
    -o APT::FTPArchive::Release::Label="Sc apps" \
    -o APT::FTPArchive::Release::Suite=stable \
    -o APT::FTPArchive::Release::Codename=stable \
    -o APT::FTPArchive::Release::Architectures="amd64 all" \
    -o APT::FTPArchive::Release::Components=main \
    -o APT::FTPArchive::Release::Description="Sc panel, Sc Notes and Sc Agenda" \
    release dists/stable > dists/stable/Release

rm -f dists/stable/InRelease dists/stable/Release.gpg
gpg --batch --yes --local-user "$KEY" --clearsign -o dists/stable/InRelease dists/stable/Release
gpg --batch --yes --local-user "$KEY" --armor --detach-sign -o dists/stable/Release.gpg dists/stable/Release

# Public key in the binary format apt's Signed-By expects.
gpg --export "$KEY" > sc-apt.gpg

echo "Repository updated:"
grep -h '^Package\|^Version' dists/stable/main/binary-amd64/Packages | paste - -
