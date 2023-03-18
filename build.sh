#!/bin/sh

set -e -x

# Final Zip Name
ZIPNAME="Woof-Kernel-test.zip"

# Kernel Config
KERNEL_DEFCONFIG="vendor/lahaina-qgki_defconfig"

# Prebuilt Clang Toolchain (AOSP)
CLANG_URL="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android13-release/clang-r450784d.tar.gz"

# Prebuilt GCC Utilities (AOSP)
GCC_x64="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9"
GCC_x32="https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.9"
GCC_BRANCH="android12L-release"

# Setup make Command
make_fun() {
	make O=out ARCH=arm64 \
		CC=clang HOSTCC=clang \
		CLANG_TRIPLE=aarch64-linux-gnu- \
		CROSS_COMPILE=aarch64-linux-android- \
		CROSS_COMPILE_ARM32=arm-linux-androideabi- "$@" 
}

# Cloning all the Necessary files
if [ ! -d clang ]; then mkdir clang && curl "${CLANG_URL}" -o clang.tgz && tar -xzf clang.tgz -C clang; fi
[ ! -d x64 ] && git clone --depth=1 "${GCC_x64}" -b "${GCC_BRANCH}" x64
[ ! -d x32 ] && git clone --depth=1 "${GCC_x32}" -b "${GCC_BRANCH}" x32

# Setting Toolchain Path
PATH="${PWD}/clang/bin:${PWD}/x64/bin:${PWD}/x32/bin:/bin"

# Installing KernelSU
curl -LSs "https://raw.githubusercontent.com/tiann/KernelSU/main/kernel/setup.sh" | bash -

# Built in Timer
SECONDS=0

[ -d "AnyKernel" ] && rm -rf AnyKernel
[ -d "out" ] && rm -rf out || mkdir -p out

# Start Compiling Kernel
make_fun "${KERNEL_DEFCONFIG}"
make_fun -j"$(nproc --all)" 2>&1 | tee build.log 

git clone --depth=1 https://github.com/cd-Seraph/AnyKernel3.git -b master AnyKernel
cp out/arch/arm64/boot/Image AnyKernel
python3 scripts/dtc/libfdt/mkdtboimg.py create AnyKernel/dtbo.img --page_size=4096 out/arch/arm64/boot/dts/vendor/oplus_7325/yupik-21643-overlay.dtbo
cd AnyKernel
zip -r9 "../$ZIPNAME" * -x .git README.md *placeholder
cd ..
echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"