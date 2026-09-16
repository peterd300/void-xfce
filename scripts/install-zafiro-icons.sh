#!/usr/bin/bash

set -euo pipefail

# make temp dir
mkdir -p "$HOME/temp"

cd "$HOME/temp"


wget -N https://github.com/zayronxio/Zafiro-icons/archive/refs/heads/master.zip
unzip master.zip 

mv -i ./Zafiro-icons-master/Dark/ $HOME/.local/share/icons/Zafiro-Dark
mv -i ./Zafiro-icons-master/Light/ $HOME/.local/share/icons/Zafiro-Light


# update icons cache
for dir in ~/.local/share/icons/*/; do
    gtk-update-icon-cache -f -t "$dir"
done

