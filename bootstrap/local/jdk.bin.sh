#!/usr/bin/env bash

echo "jdk-programming"

echo "sdkman"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version

echo "java"
sdk install java
java -version

echo "clojure"
wget https://download.clojure.org/install/linux-install-1.10.3.1020.sh -O $HOME/Downloads/clojure-install.sh
sh $HOME/Downloads/clojure-install.sh --prefix $HOME/.local
rm -vf $HOME/Downloads/clojure-install.sh
clj -h

echo "lein"
sdk install leiningen
lein version
