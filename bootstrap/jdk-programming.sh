#!/usr/bin/env bash

echo "jdk-programming"
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
