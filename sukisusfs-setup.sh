#!/usr/bin/env bash
set -euo pipefail

# check folder
[ -d fs ] && [ -d include/linux ] || {
  echo "ERROR: run this from kernel root"
  exit 1
}

# 1. Setup SukiSU builtin
curl -LSs https://raw.githubusercontent.com/SukiSU-Ultra/SukiSU-Ultra/main/kernel/setup.sh \
  | bash -s builtin

# 2. Clone SUSFS (gki android12-5.10)
if [ ! -d susfs4ksu ]; then
  git clone https://gitlab.com/simonpunk/susfs4ksu.git -b gki-android12-5.10
fi

# 3. Copy kernel patches
cp susfs4ksu/kernel_patches/fs/* fs/
cp susfs4ksu/kernel_patches/include/linux/* include/linux/

# 4. Apply patch
patch -p1 < susfs4ksu/kernel_patches/50_add_susfs_in_gki-android12-5.10.patch
echo "DONE: SukiSU builtin SUSFS applied"
