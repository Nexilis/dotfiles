#!/usr/bin/env bash

echo "micro"
rm -f micro
curl https://getmic.ro | bash
rm -f $HOME/.local/bin/micro
mv micro $HOME/.local/bin/micro
