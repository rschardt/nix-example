set -e
unset PATH
for p in $buildInputs; do
  export PATH=$p/bin${PATH:+:}$PATH
done

rustc $src/hello.rs

mkdir -p $out
mv ./hello $out
