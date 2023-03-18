#!/bin/sh

set -e -x

# Final Zip Name
ZIPNAME="Void-Kernel-test.zip"

# Kernel Config
KERNEL_DEFCONFIG="vendor/lahaina-qgki_defconfig"

# Prebuilt Clang Toolchain (AOSP)
CLANG_URL="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android13-release/clang-r450784d.tar.gz"

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

# Setting Toolchain Path
PATH="${PWD}/clang/bin:/bin"

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