#!/usr/bin/env bash

if [ "z"$1 = "z" ]; then
    echo Usage: $0 "version"
    exit 1
fi

set -euo pipefail

export VERS=$1
prefix_dir="$HOME/tps/clojure-tools-$VERS"

mkdir -p $prefix_dir/.temp
cd $prefix_dir/.temp

echo "Downloading and expanding tar"
curl -O https://download.clojure.org/install/clojure-tools-${VERS}.tar.gz
tar xzf clojure-tools-${VERS}.tar.gz

lib_dir="$prefix_dir/lib"
bin_dir="$prefix_dir/bin"
man_dir="$prefix_dir/share/man/man1"
clojure_lib_dir="$lib_dir/clojure"

echo "Installing libs into $clojure_lib_dir"
mkdir -m 775 -p $clojure_lib_dir/libexec
install -m644 clojure-tools/deps.edn "$clojure_lib_dir/deps.edn"
install -m644 clojure-tools/example-deps.edn "$clojure_lib_dir/example-deps.edn"
install -m644 clojure-tools/exec.jar "$clojure_lib_dir/libexec/exec.jar"
install -m644 clojure-tools/clojure-tools-${VERS}.jar "$clojure_lib_dir/libexec/clojure-tools-${VERS}.jar"

echo "Installing clojure and clj into $bin_dir"
sed -i -e 's@PREFIX@'"$clojure_lib_dir"'@g' clojure-tools/clojure
mkdir -m 775 -p $bin_dir
install -m755 clojure-tools/clojure "$bin_dir/clojure"
install -m755 clojure-tools/clj "$bin_dir/clj"

echo "Installing man pages into $man_dir"
mkdir -m 775 -p $man_dir
install -m644 clojure-tools/clojure.1 "$man_dir/clojure.1"
install -m644 clojure-tools/clj.1 "$man_dir/clj.1"

# echo "Removing download"
# rm -rf clojure-tools
# rm -rf clojure-tools-${VERS}.tar.gz
# cd ..
# rmdir .temp

echo "Use clj -h for help."
