#!/usr/bin/bash
set -euo pipefail

# make temp dir
mkdir -p "$HOME/temp"

# extract tar file in  $HOME/temp
cd $HOME/void-xfce/themes-icons

# extract themes
for archive in Prof-XFCE-2.1.tar.gz Win11-round.tar.xz Win11-round-Dark.tar.xz Win11-round-Light.tar.xz \
			   Desert-Teal-Blue-XFCE-1.3.tar.xz Desert-Teal-Dark-40.tar.xz Desert-Teal-light-40.tar.xz ; do
    tar -xf "$archive" -C "$HOME/temp"
done

# extract icons

for archive in 01-Tela.tar.xz 01-Fluent.tar.xz ; do
    tar -xf "$archive" -C "$HOME/temp"
done


# ensure target dirs exist
mkdir -p ~/.local/share/icons ~/.local/share/themes

cd "$HOME/temp"

# install themes
mv "Prof--XFCE- 2.1/" ~/.local/share/themes/
mv Win11-round*/ ~/.local/share/themes/
mv Desert-Teal*/ ~/.local/share/themes/

# install icons 
mv Tela*/ ~/.local/share/icons/
mv Fluent*/ ~/.local/share/icons/

cd ..

