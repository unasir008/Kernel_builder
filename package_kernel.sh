#!/bin/bash

# Package Kernel Script
# Creates a zip file containing the kernel image

KERNEL_DIR="$(pwd)"
OUTPUT_DIR="${KERNEL_DIR}/out"
KERNEL_IMAGE="Image"
RELEASE_NAME="MyKernel-$(date +%Y%m%d-%H%M%S)"

# Package the kernel
echo "Packaging kernel..."
cd "${KERNEL_DIR}" || {
    echo "Error: Failed to change to kernel directory ${KERNEL_DIR}"
    exit 1
}
mkdir -p release
cp "${OUTPUT_DIR}/arch/arm64/boot/${KERNEL_IMAGE}" "release/${KERNEL_IMAGE}" || {
    echo "Error: Kernel image not found at ${OUTPUT_DIR}/arch/arm64/boot/${KERNEL_IMAGE}"
    exit 1
}
# Also copy the image from arch/arm64/boot/Image if it exists (as per your build_kernel.sh)
if [[ -f "${KERNEL_DIR}/arch/arm64/boot/${KERNEL_IMAGE}" ]]; then
    cp "${KERNEL_DIR}/arch/arm64/boot/${KERNEL_IMAGE}" "release/${KERNEL_IMAGE}-backup" || {
        echo "Error: Failed to copy ${KERNEL_DIR}/arch/arm64/boot/${KERNEL_IMAGE}"
        exit 1
    }
fi
zip -r "${RELEASE_NAME}.zip" release/ || {
    echo "Error: Failed to create zip package"
    exit 1
}
echo "Kernel packaged as ${RELEASE_NAME}.zip"
