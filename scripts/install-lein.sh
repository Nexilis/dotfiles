#!/usr/bin/env bash

curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein > ~/lein
chmod +x ~/lein
sudo mv ~/lein /bin
lein -v
