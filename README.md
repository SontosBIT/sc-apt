<img src="sc-panel.svg" alt="Sc panel logo" width="96">

# Sc apps apt repository

Install page: https://sontosbit.github.io/sc-apt/

```sh
curl -fsSL https://sontosbit.github.io/sc-apt/setup.sh | sudo sh
sudo apt install sc-panel
sc-panel-enable        # then log out and back in
```

## Packages

| Package | What it is |
|---|---|
| `sc-panel` | Sc panel GNOME Shell extension (GNOME 46) |

## Publishing a new version

1. Build the `.deb` (for Sc panel: `packaging/build-deb.sh <version>` in its repo).
2. Copy it into `pool/main/`.
3. Run `scripts/update-repo.sh` to rebuild and sign the index.
4. Commit and push; GitHub Pages serves the update within a minute or two.

Signing needs the "Sc apps APT repository" GPG key
(`AE97BFD044F4390F30F3031E79B3BFD1E311F83C`), which only lives on the
maintainer's computer. Keep a backup of it.
