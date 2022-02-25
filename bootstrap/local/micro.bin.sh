#!/usr/bin/env bash

echo "micro"
rm -vf micro
curl https://getmic.ro | bash
mv -vf micro $HOME/.local/bin/micro
chmod u+x $HOME/.local/bin/micro
