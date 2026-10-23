#!/usr/bin/env nix-shell
#!nix-shell -i bash -p keymap-drawer

set -euo pipefail

cd "$(dirname "$0")"
mkdir -p keymap-drawer
keymap -c keymap_drawer.config.yaml parse -z config/cradio.keymap >keymap-drawer/cradio.yaml
keymap -c keymap_drawer.config.yaml draw keymap-drawer/cradio.yaml >keymap-drawer/cradio.svg
