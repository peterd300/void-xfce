#!/usr/bin/bash
set -euo pipefail

cd $HOME/void-xfce/themes-icons

# extract themes
for archive in Prof-XFCE-2.1.tar.gz Win11-round.tar.xz Win11-round-Dark.tar.xz Win11-round-Light.tar.xz; do
    tar -xf "$archive"
done

# extract icons
tar -xf 01-Tela.tar.xz

# ensure target dirs exist
mkdir -p ~/.local/share/icons ~/.local/share/themes

# install themes
mv "Prof--XFCE- 2.1/" ~/.local/share/themes/
mv Win11-round*/ ~/.local/share/themes/

# install icons (needs root)
sudo mv Tela*/ /usr/share/icons/
