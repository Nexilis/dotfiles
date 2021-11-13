#!/usr/bin/env bash

wget https://download.visualstudio.microsoft.com/download/pr/17b6759f-1af0-41bc-ab12-209ba0377779/e8d02195dbf1434b940e0f05ae086453/dotnet-sdk-6.0.100-linux-x64.tar.gz -O $HOME/Downloads/dotnet-sdk.tar.gz
rm -rf $HOME/.local/share/dotnet
mkdir -p $HOME/.local/share/dotnet
tar xvzf $HOME/Downloads/dotnet-sdk.tar.gz -C $HOME/.local/share/dotnet
chmod u+x $HOME/.local/share/dotnet/dotnet
ln -sf $HOME/.local/share/dotnet/dotnet $HOME/.local/bin/dotnet
rm -rf $HOME/Downloads/dotnet-sdk.tar.gz
