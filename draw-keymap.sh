#!/usr/bin/env nix-shell
#!nix-shell -i bash -p keymap-drawer librsvg

set -euo pipefail

cd "$(dirname "$0")"
mkdir -p keymap-drawer
keymap -c keymap_drawer.config.yaml parse -z config/cradio.keymap >keymap-drawer/ferris-sweep.yaml

# Add the FUN annotation to the NUM and NAV layers
sed 's/{t: ▽, type: trans}/FUN/' keymap-drawer/ferris-sweep.yaml >keymap-drawer/ferris-sweep.yaml.tmp
mv keymap-drawer/ferris-sweep.yaml.tmp keymap-drawer/ferris-sweep.yaml

keymap -c keymap_drawer.config.yaml draw keymap-drawer/ferris-sweep.yaml >keymap-drawer/ferris-sweep.svg
rsvg-convert -a -w 1024 -o keymap-drawer/ferris-sweep.png keymap-drawer/ferris-sweep.svg
