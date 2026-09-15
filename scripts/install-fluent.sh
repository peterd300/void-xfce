#!/bin/bash

# install fluent icons


tempdir="$HOME/temp"

mkdir $tempdir
cd $tempdir

tar -xvf ~/void-xfce/themes-icons/01-Fluent.tar.xz

mv Fluent*/ $HOME/.local/share/icons/

