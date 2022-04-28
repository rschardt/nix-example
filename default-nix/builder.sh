set -e
unset PATH
for p in $buildInputs; do
  export PATH=$p/bin${PATH:+:}$PATH
done

mkdir -p $out
echo "hello world" | tee example.txt
mv example.txt $out
