#!/bin/bash

ARCH='x86_64'
MIRROR='https://mirrors.kernel.org/archlinux/'

wget "${MIRROR}/community/os/${ARCH}/community.db"
wget "${MIRROR}/core/os/${ARCH}/core.db"
wget "${MIRROR}/extra/os/${ARCH}/extra.db"
wget "${MIRROR}/multilib/os/${ARCH}/multilib.db"