#!/bin/sh

set -e -x

# Kernel Config
KERNEL_DEFCONFIG="vendor/lahaina-qgki_defconfig"

# Clang directory
CLANG_DIR="clang"

# Prebuilt Clang Toolchain (AOSP)
CLANG_URL="https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86/+archive/refs/heads/android13-release/clang-r450784d.tar.gz"

# Final Zip Name
ZIPNAME="Woof-RMX3461-$(date '+%Y%m%d-%H%M').zip"

# Setup make Command
make_fun() {
	make O=out ARCH=arm64 \
		CC=clang HOSTCC=clang \
		CROSS_COMPILE=${CLANG_DIR}/bin/llvm- \
		LLVM=1 \
		LLVM_IAS=1 \
		CLANG_TRIPLE=aarch64-linux-gnu- 
}

# Cloning all the Necessary files
if [ ! -d ${CLANG_DIR} ]; then mkdir ${CLANG_DIR} && curl "${CLANG_URL}" -o clang.tgz && tar -xzf clang.tgz -C ${CLANG_DIR}; fi

# Setting Toolchain Path
PATH="${CLANG_DIR}/bin:${PATH}"

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
cp out/arch/arm64/boot/dts/vendor/oplus_7325/yupik.dtb AnyKernel/dtb
python3 scripts/dtc/libfdt/mkdtboimg.py create AnyKernel/dtbo.img --page_size=4096 out/arch/arm64/boot/dts/vendor/oplus_7325/yupik-21643-overlay.dtbo
cd AnyKernel
zip -r9 "../$ZIPNAME" * -x .git README.md *placeholder
cd ..
echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
