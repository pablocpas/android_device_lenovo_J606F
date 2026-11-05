#
# Copyright (C) 2022-2023 The LineageOS Project
# Copyright (C) 2026 Lenovo Tab P11 (TB-J606F) native port
#
# SPDX-License-Identifier: Apache-2.0
#
# Basado en device/fxtec/pro1x (lineage-23.2, misma plataforma bengal).
# Valores de particiones, cabecera de arranque y cmdline verificados contra el
# firmware TB-J606F_S320383_240603_ROW (ver docs/PLAN_ROM_NATIVA.md).
#

DEVICE_PATH := device/lenovo/J606F

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    product \
    recovery \
    system \
    system_ext \
    vbmeta \
    vbmeta_system \
    vendor

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := kryo

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a73

# Audio
AUDIO_FEATURE_ENABLED_DLKM := true
AUDIO_FEATURE_ENABLED_EXTENDED_COMPRESS_FORMAT := true
AUDIO_FEATURE_ENABLED_EXT_AMPLIFIER := true
AUDIO_FEATURE_ENABLED_GEF_SUPPORT := true
AUDIO_FEATURE_ENABLED_HW_ACCELERATED_EFFECTS := false
AUDIO_FEATURE_ENABLED_INSTANCE_ID := true
AUDIO_FEATURE_ENABLED_PROXY_DEVICE := true
AUDIO_FEATURE_ENABLED_SSR := true
AUDIO_FEATURE_ENABLED_SVA_MULTI_STAGE := true
BOARD_SUPPORTS_SOUND_TRIGGER := true
BOARD_USES_ALSA_AUDIO := true

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := bengal

# Display
TARGET_SCREEN_DENSITY := 240

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/config.fs

# HIDL
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += hardware/qcom-caf/common/vendor_framework_compatibility_matrix.xml
DEVICE_MATRIX_FILE := hardware/qcom-caf/common/compatibility_matrix.xml
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml

# Kernel
# Fase 1: kernel stock de Lenovo (4.19.157-perf+, S320383) precompilado, con
# sus modulos firmados (CONFIG_MODULE_SIG_FORCE=y) instalados como blobs.
# Android 16 ya ha arrancado sobre este kernel en esta placa (GSI de frnikho).
# Las cabeceras para los HAL se generan desde TARGET_KERNEL_SOURCE, que es el
# mismo 4.19.157 de Lenovo (StyloGey), asi que coinciden con el binario.
# Fase 2: quitar TARGET_FORCE_PREBUILT_KERNEL para compilarlo desde fuentes.
BOARD_BOOT_HEADER_VERSION := 2
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := \
    console=ttyMSM0,115200n8 \
    earlycon=msm_geni_serial,0x4a90000 \
    androidboot.hardware=qcom \
    androidboot.console=ttyMSM0 \
    androidboot.memcg=1 \
    lpm_levels.sleep_disabled=1 \
    video=vfb:640x400,bpp=32,memsize=3072000 \
    msm_rtb.filter=0x237 \
    service_locator.enable=1 \
    swiotlb=2048 \
    loop.max_part=7 \
    firmware_class.path=/vendor/firmware/awinic
# Solo para depurar el primer arranque (userdebug): J606F_SELINUX_PERMISSIVE=true m ...
# La ROM final se compila sin esto (SELinux enforcing).
ifeq ($(J606F_SELINUX_PERMISSIVE),true)
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
endif
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
# El kernel stock solo descomprime ramdisks gzip (CONFIG_RD_LZ4 no esta activo):
# BOARD_RAMDISK_USE_LZ4 solo con el 4.19.325.
TARGET_KERNEL_NO_GCC := true
TARGET_FORCE_PREBUILT_KERNEL := true
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
# J606F_KERNEL=4.19.325 usa el kernel de kernel/lenovo/sm6115 empaquetado por
# android/scripts/empaquetar_kernel_j606f.sh: DTB de stock con ramoops, y modulos
# con los nombres de stock. Las cabeceras de los HAL salen de ese mismo arbol.
ifeq ($(J606F_KERNEL),4.19.325)
TARGET_KERNEL_SOURCE := kernel/lenovo/sm6115
TARGET_KERNEL_CONFIG := vendor/bengal-perf_defconfig vendor/ext_config/j606f.config
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel-4.19.325/Image.gz
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/kernel-4.19.325/dtb
BOARD_RAMDISK_USE_LZ4 := true
else
TARGET_KERNEL_SOURCE := kernel/msm-4.19
TARGET_KERNEL_CONFIG := vendor/j606f_defconfig
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
BOARD_PREBUILT_DTBIMAGE_DIR := $(DEVICE_PATH)/prebuilt/dtb
endif

# Media
TARGET_USES_ION := true

# Metadata
BOARD_USES_METADATA_PARTITION := true

# Partitions (tabla rawprogram de S320383, sector UFS 4096)
-include vendor/lineage/config/BoardConfigReservedSize.mk
BOARD_BOOTIMAGE_PARTITION_SIZE := 100663296
BOARD_DTBOIMG_PARTITION_SIZE := 25165824
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 100663296
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
# super de 12 GiB; mismo grupo y tamano que el stock (lpdump de la unidad)
# para poder flashear desde fastbootd sin reescribir la metadata de super.
BOARD_SUPER_PARTITION_SIZE := 12884901888
BOARD_SUPER_PARTITION_GROUPS := qti_dynamic_partitions
BOARD_QTI_DYNAMIC_PARTITIONS_SIZE := 6438256640
BOARD_QTI_DYNAMIC_PARTITIONS_PARTITION_LIST := product system system_ext vendor
BOARD_FLASH_BLOCK_SIZE := 262144 # BOARD_KERNEL_PAGESIZE * 64
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_VENDOR := vendor

# Platform
BOARD_USES_QCOM_HARDWARE := true
TARGET_BOARD_PLATFORM := bengal

# Recovery
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/init/fstab.default
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Security: parche de vendor del firmware del que salen los blobs (S320383)
VENDOR_SECURITY_PATCH := 2024-05-05

# SEPolicy
include device/qcom/sepolicy_vndr/SEPolicy.mk
include $(DEVICE_PATH)/sepolicy/SEPolicy.mk

# Verified Boot
BOARD_AVB_ENABLE := true

ifneq (,$(AVB_CUSTOM_KEY_PATH))
BOARD_AVB_ALGORITHM := $(AVB_CUSTOM_ALGORITHM)
BOARD_AVB_KEY_PATH := $(AVB_CUSTOM_KEY_PATH)
else
AVB_CUSTOM_ALGORITHM := SHA256_RSA2048
AVB_CUSTOM_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
endif

ifneq ($(WITH_AVB),true)
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
endif

BOARD_AVB_VBMETA_SYSTEM := system system_ext product
BOARD_AVB_VBMETA_SYSTEM_ALGORITHM := $(AVB_CUSTOM_ALGORITHM)
BOARD_AVB_VBMETA_SYSTEM_KEY_PATH := $(AVB_CUSTOM_KEY_PATH)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_VBMETA_SYSTEM_ROLLBACK_INDEX_LOCATION := 2

# WiFi
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := $(BOARD_HOSTAPD_DRIVER)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := $(BOARD_HOSTAPD_PRIVATE_LIB)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_EVENT := "ON"
WIFI_DRIVER_STATE_CTRL_PARAM := "/dev/wlan"
WIFI_DRIVER_STATE_OFF := "OFF"
WIFI_DRIVER_STATE_ON := "ON"
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WIFI_HIDL_UNIFIED_SUPPLICANT_SERVICE_RC_ENTRY := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Include the proprietary files BoardConfig.
include vendor/lenovo/J606F/BoardConfigVendor.mk
