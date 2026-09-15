#!/bin/env bash


mkdir -p ~/temp

cd ~/temp

git clone https://github.com/mdgiii/Cinnamon-theme-Windows-10.git

cd Cinnamon-theme-Windows-10/

mv Win10-icons/ ~/.local/share/icons/
mv Win10-theme/ ~/.local/share/themes/

