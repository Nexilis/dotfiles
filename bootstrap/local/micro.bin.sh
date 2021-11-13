#!/usr/bin/env bash

echo "micro"
rm -f micro
curl https://getmic.ro | bash
mv -f micro $HOME/.local/bin/micro
chmod u+x $HOME/.local/bin/micro
