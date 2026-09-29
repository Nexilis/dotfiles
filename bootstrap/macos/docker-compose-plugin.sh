#!/usr/bin/env bash
# Homebrew installs docker-compose as a standalone binary; `docker compose`
# only finds it as a CLI plugin. The CubeJs stack scripts call `docker compose`.
set -uo pipefail

src="$(brew --prefix)/opt/docker-compose/bin/docker-compose"
if [[ ! -x "$src" ]]; then
  echo "docker-compose not installed; run the brew steps of the work group first" >&2
  exit 1
fi

mkdir -p "$HOME/.docker/cli-plugins"
ln -sfn "$src" "$HOME/.docker/cli-plugins/docker-compose"
docker compose version
