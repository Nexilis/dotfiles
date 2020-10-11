#!/usr/bin/env bash

echo "adoptopenjdk java, leiningen, clojure"
wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
sudo apt-get update
sudo apt-get install adoptopenjdk-14-hotspot rlwrap -y
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O $HOME/Downloads/lein
sudo mv ~/Downloads/lein /usr/local/bin/lein
sudo chmod a+x /usr/local/bin/lein
wget https://download.clojure.org/install/linux-install-1.10.1.536.sh -O $HOME/Downloads/clj-install.sh
chmod +x $HOME/Downloads/clj-install.sh
sudo $HOME/Downloads/clj-install.sh
rm -rf $HOME/Downloads/clj-install.sh
java -version
lein version
clj -h
