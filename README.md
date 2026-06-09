# Quick start

Clone anywhere; the bootstrap scripts are self-locating and configs deploy as
symlinks back into the clone, so the path no longer matters.

1. Clone the repo (this example uses `~/code/gh/prv/dotfiles`):

    `$ git clone git@github.com:Nexilis/dotfiles.git ~/code/gh/prv/dotfiles`

2. Run the bootstrap script for your OS:

    `$ sh ~/code/gh/prv/dotfiles/bootstrap/bootstrap-fedora.sh`

    `$ sh ~/code/gh/prv/dotfiles/bootstrap/bootstrap-ubuntu.sh`

    `$ sh ~/code/gh/prv/dotfiles/bootstrap/bootstrap-macos.sh`

To only (re)link configs without installing anything, run
`bootstrap/_link.sh` (use `--dry-run` to preview, `--force` to replace files
that differ from the repo; replaced files are backed up).
