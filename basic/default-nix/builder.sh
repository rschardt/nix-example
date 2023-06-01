set -e

source $stdenv/setup

rustc $mySrc/hello.rs

mkdir -p $out
mv ./hello $out

find $out -type f -exec patchelf --shrink-rpath '{}' \; -exec strip '{}' \; 2>/dev/null
