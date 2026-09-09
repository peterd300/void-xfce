# Install gzdoom and several doom wad files
# Back to the old days :)
# see https://github.com/Akbar30Bill/DOOM_wads/tree/master for more files


#!/usr/bin/env bash

# install emulator
sudo xbps-install -Suy gzdoom

mkdir -p ~/.config/gzdoom
cp ~/void-xfce/scripts/gzdoom.ini  ~/config/gzdoom/.


#Download some wad files
cd ~
mkdir -p ~/games
cd games


wget https://raw.githubusercontent.com/Akbar30Bill/DOOM_wads/refs/heads/master/doom.wad
wget https://raw.githubusercontent.com/Akbar30Bill/DOOM_wads/refs/heads/master/doom2.wad
# echo "Start gzdoom from this directory ~/games/."
