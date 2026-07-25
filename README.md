# Quick start

Clone anywhere; the bootstrap scripts are self-locating and configs deploy as
symlinks back into the clone, so the path no longer matters.

1. Clone the repo (this example uses `~/code/gh/prv/dotfiles`):

    `$ git clone https://github.com/Nexilis/dotfiles.git ~/code/gh/prv/dotfiles`

2. Run the bootstrap script for your OS:

    `$ sh ~/code/gh/prv/dotfiles/bootstrap/bootstrap-macos.sh`

    `$ sh ~/code/gh/prv/dotfiles/bootstrap/bootstrap-fedora.sh`

    `$ sh ~/code/gh/prv/dotfiles/bootstrap/bootstrap-ubuntu.sh`

## macOS: pick what gets installed

`bootstrap-macos.sh` asks y/n for each package group, then symlinks the configs.
Nothing else has to be remembered.

    $ sh bootstrap/bootstrap-macos.sh                  # y/n per group
    $ sh bootstrap/bootstrap-macos.sh --all            # every group
    $ sh bootstrap/bootstrap-macos.sh --skip-packages  # only link configs
    $ sh bootstrap/bootstrap-macos.sh --dry-run        # change nothing

The package list lives in `bootstrap/macos-packages.txt`. Afterwards, single
groups run straight from the justfile:

    $ cd bootstrap
    $ just              # list every recipe
    $ just groups       # groups with package counts
    $ just apps         # install one group
    $ just group git files

## Configs only

To (re)link configs without installing anything, run `bootstrap/_link.sh`
(or `just link`). Use `--dry-run` to preview and `--force` to replace files that
differ from the repo; replaced files are backed up.
