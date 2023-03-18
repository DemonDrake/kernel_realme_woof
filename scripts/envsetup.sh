#!/bin/sh

set -e -x

CLANG_URL="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android13-release/clang-r450784d.tar.gz"

sudo apt-get update && sudo apt-get install bc git zip make tar libncurses* gcc clang python3 openssl util-linux perl binutils e2fsprogs udev build-essential bison flex libssl-dev libelf-dev -y

if [ ! -d ${CLANG_DIR} ]; then mkdir ${CLANG_DIR} && curl "${CLANG_URL}" -o clang.tgz && tar -xzf clang.tgz -C ${CLANG_DIR}; fi
