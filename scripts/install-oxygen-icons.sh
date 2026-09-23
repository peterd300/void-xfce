#!/usr/bin/bash

set -euo pipefail

theme="Oxygen"
destdir="$HOME/.local/share/icons/$theme"


logdir="$HOME/log"
log_file="$logdir/${theme}.log"

exec > >(tee -a "$log_file") 2>&1

# make temp dir
mkdir -p "$HOME/temp"

cd "$HOME/temp"

git clone https://github.com/KDE/oxygen-icons.git --depth=1
cd oxygen-icons


mkdir -p "$destdir"

# Move scalable SVGs: scalable/<context>/<icon>.svg
if [ -d scalable ]; then
  find scalable -name '*.svg' | while read -r f; do
    rel=${f#scalable/}
    context=${rel%/*}
    mkdir -p "$destdir/scalable/$context"
    echo "Moving $f to $destdir/scalable/$context/"
    mv -i "$f" "$destdir/scalable/$context/"
  done
fi

# Move rendered PNGs: <size>x<size>/<context>/<icon>.png
for size in 8 16 22 24 32 48 64 128 256; do
  dir="${size}x${size}"
  [ -d "$dir" ] || continue

  find "$dir" -name '*.png' | while read -r f; do
    rel=${f#$dir/}
    context=${rel%/*}
    mkdir -p "$destdir/$dir/$context"
    echo "Moving $f to $destdir/$dir/$context/"
    mv -i "$f" "$destdir/$dir/$context/"
  done
done

cp ./index.theme "$destdir"


# update icons cache
for dir in ~/.local/share/icons/*/; do
    gtk-update-icon-cache -f -t "$dir"
done

