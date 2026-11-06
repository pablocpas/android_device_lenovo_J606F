#
# Copyright (C) 2022-2025 The LineageOS Project
# Copyright (C) 2026 Lenovo Tab P11 (TB-J606F) native port
#
# SPDX-License-Identifier: Apache-2.0
#
# Basado en device/fxtec/pro1x (lineage-23.2). Cambios para la J606F:
# tablet solo Wi-Fi (sin RIL/IMS/telefonia), sin NFC, huella, FM ni teclado
# deslizante; audio con 4x AW88258; overlays y keylayouts de Lenovo.
#

# Add common definitions for Qualcomm
$(call inherit-product, hardware/qcom-caf/common/common.mk)

# A/B
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# AAPT (1200x2000 a 240 dpi)
PRODUCT_AAPT_CONFIG := normal large xlarge
PRODUCT_AAPT_PREF_CONFIG := hdpi

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.audio.service \
    android.hardware.bluetooth.audio-impl \
    android.hardware.soundtrigger@2.3-impl \
    audio.bluetooth.default \
    audio.primary.bengal \
    audio.r_submix.default \
    audio.usb.default \
    audio_amplifier.j606f \
    liba2dpoffload \
    libbatterylistener \
    libcomprcapture \
    libexthwplugin \
    libhdmiedid \
    libqcompostprocbundle \
    libqcomvisualizer \
    libqcomvoiceprocessing \
    libsndmonitor \
    libssrec \
    libvolumelistener

AUDIO_HAL_DIR := hardware/qcom-caf/sm8250/audio

PRODUCT_COPY_FILES += \
    $(AUDIO_HAL_DIR)/configs/bengal/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(AUDIO_HAL_DIR)/configs/bengal/audio_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info.xml

# Configuracion de audio de la J606F (stock S320383 adaptada por StyloGey/AOSPA)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/audio_io_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_io_policy.conf \
    $(LOCAL_PATH)/configs/audio/audio_platform_info_intcodec.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_platform_info_intcodec.xml \
    $(LOCAL_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_bengal_idp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml \
    $(LOCAL_PATH)/configs/audio/mixer_paths_bengal_idp.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths_bengal_idp.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_mixer_paths.xml \
    $(LOCAL_PATH)/configs/audio/sound_trigger_platform_info.xml:$(TARGET_COPY_OUT_VENDOR)/etc/sound_trigger_platform_info.xml

PRODUCT_COPY_FILES += \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.hardware.audio.pro.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.pro.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml

# Bluetooth
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml

# Boot Animation (pantalla 1200x2000)
TARGET_SCREEN_HEIGHT := 2000
TARGET_SCREEN_WIDTH := 1200

# Boot Control
PRODUCT_PACKAGES += \
    android.hardware.boot-service.qti \
    android.hardware.boot-service.qti.recovery

$(call soong_config_set_bool,QTI_GPT_UTILS,USE_BSG_FRAMEWORK,false)

# Camera
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service_64 \
    gralloc.qcom \
    vendor.qti.hardware.camera.device@1.0.vendor

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml

# Configstore
PRODUCT_PACKAGES += \
    disable_configstore

# Characteristics
PRODUCT_CHARACTERISTICS := tablet

# Dalvik: mismos valores que el stock S320383 (definidos en vendor.prop)

# Device ID attestation
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml

# Display
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@3.0-impl-qti-display \
    android.hardware.graphics.mapper@4.0-impl-qti-display \
    libsdmcore \
    libvulkan \
    vendor.qti.hardware.display.allocator-service \
    vendor.qti.hardware.display.composer-service \
    vendor.qti.hardware.memtrack-service

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml

# DRM
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey \
    init.j606f.drm.rc \
    liboemcrypto-vacio.so

# Widevine: L3 mientras L1 haga caer el firmware de video (init/init.j606f.drm.rc).
# Con J606F_WIDEVINE_L1=true se deja L1, para probarlo.
ifneq ($(J606F_WIDEVINE_L1),true)
PRODUCT_VENDOR_PROPERTIES += \
    ro.vendor.j606f.widevine_l3=true
endif

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl.custom \
    fastbootd

# GNSS
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/gps/gps.conf:$(TARGET_COPY_OUT_VENDOR)/etc/gps.conf

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml

# Graphics
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-1.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.qti

# IPACM (offload de tethering por hardware IPA)
PRODUCT_PACKAGES += \
    IPACM_cfg.xml \
    ipacm

# Init
PRODUCT_PACKAGES += \
    fstab.default \
    fstab.default.ramdisk \
    fstab.zram \
    init.class_main.sh \
    init.lineage.rc \
    init.qcom.early_boot.sh \
    init.qcom.post_boot.sh \
    init.qcom.rc \
    init.qcom.recovery.rc \
    init.qcom.sh \
    init.qcom.usb.rc \
    init.qcom.usb.sh \
    init.target.rc \
    init.j606f.perf.rc \
    ueventd.qcom.rc

# Input: teclas de volumen, teclado y touchpad del dock Lenovo
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/keylayout/gpio-keys.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/gpio-keys.kl \
    $(LOCAL_PATH)/configs/keylayout/Vendor_17ef_Product_6103.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_17ef_Product_6103.kl \
    $(LOCAL_PATH)/configs/idc/Vendor_04f3_Product_3164.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Vendor_04f3_Product_3164.idc \
    $(LOCAL_PATH)/configs/idc/Vendor_beef_Product_dead.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Vendor_beef_Product_dead.idc

# Lights
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage

# Kernel
# Lineage genera las cabeceras con su propio generated_kernel_includes.
# Los Android.bp heredados de CAF dentro del kernel definen otra copia de
# qti_kernel_headers; excluirlos del grafo Soong conserva las fuentes para
# headers_install y para compilar el kernel con make.
PRODUCT_SOURCE_ROOT_DIRS += -kernel/msm-4.19

# PRODUCT_SOURCE_ROOT_DIRS solo filtra Soong: kati sigue incluyendo los
# Android.mk del kernel. El de techpack/audio redefine audio_kernel_headers
# (ya en hardware/qcom-caf/common) y construye modulos DLKM que no se usan con
# el kernel precompilado. Se permiten todos los Android.mk salvo los del kernel.
PRODUCT_IGNORE_ALL_ANDROIDMK := true
PRODUCT_ALLOWED_ANDROIDMK_FILES := \
    bootable/deprecated-ota/updater/Android.mk \
    hardware/broadcom/wlan/bcmdhd/Android.mk \
    hardware/qcom/Android.mk \
    hardware/synaptics/wlan/synadhd/Android.mk \
    vendor/lenovo/J606F/Android.mk

# El kernel stock tiene CONFIG_USERFAULTFD desactivado y no tiene MREMAP_DONTUNMAP.
# Con "true", ART descartaria el dexpreopt al arrancar y lo regeneraria en la tablet.
# El 4.19.325 tiene los dos, como exige el recolector CMC de ART.
ifeq ($(J606F_KERNEL),4.19.325)
PRODUCT_ENABLE_UFFD_GC := true
# Mismo nivel de BPF que el Pro1-X con este kernel.
PRODUCT_PRODUCT_PROPERTIES += \
    ro.bpf.kver_override=5.10.239
else
PRODUCT_ENABLE_UFFD_GC := false
endif

# Lineage Health
PRODUCT_PACKAGES += \
    vendor.lineage.health-service.default

# Media
PRODUCT_PACKAGES += \
    init.qti.media.sh \
    libOmxCore \
    libOmxVdec \
    libOmxVenc \
    libstagefrighthw

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/configs/media/media_codecs_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(LOCAL_PATH)/configs/media/media_profiles.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles.xml \
    $(LOCAL_PATH)/configs/media/media_profiles_vendor.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_vendor.xml

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_PACKAGES += \
    FrameworksOverlay \
    Launcher3DeviceOverlay \
    LineageSDKResCommon \
    LineageSettingsProviderOverlay \
    SettingsOverlay \
    SettingsProviderOverlay \
    SystemUIOverlay \
    WifiOverlay

# Partitions
PRODUCT_PACKAGES += \
    vendor_bt_firmware_mountpoint \
    vendor_dsp_mountpoint \
    vendor_firmware_mnt_mountpoint

PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Power: HAL QTI abierto + powerhint de bengal. Usa el perf HAL de Qualcomm
# (vendor.qti.hardware.perf@2.2) para los boosts de toque, lanzamiento y
# animacion que una GSI no puede usar (ver docs/PLAN_ROM_NATIVA.md, seccion 5).
PRODUCT_PACKAGES += \
    android.hardware.power-service-qti

$(call soong_config_set,qtipower,mode_ext_lib,//$(LOCAL_PATH)/power:libpowermode-ext-j606f)

PRODUCT_COPY_FILES += \
    vendor/qcom/opensource/power/config/bengal/powerhint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.xml

# Seccomp policy
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/seccomp/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.multihal

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.qti

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-service.qti

PRODUCT_SOONG_NAMESPACES += \
    vendor/qcom/opensource/usb/etc

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml

# Vendor service manager
PRODUCT_PACKAGES += \
    vndservicemanager

# Verified Boot
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml

# Tablet: sin esto faltan app_widgets, home_screen e input_methods, y el launcher
# entra en bucle (Service appwidget: not found).
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/tablet_core_hardware.xml

# Vibrator: la J606F no tiene motor de vibracion (no se incluye HAL)

# VNDK / API: la J606F se lanzo con Android 10 (API 29)
PRODUCT_SHIPPING_API_LEVEL := 29

# El kernel stock 4.19.157 no alcanza el minimo de las matrices VINTF (4.19.325).
# Solo omite la comprobacion del kernel al compilar; HAL y manifiestos se siguen
# validando, y Android tampoco comprueba el kernel al arrancar (verifyBuildAtBoot
# usa disableKernel). Con el 4.19.325 se podria activar (lleva CONFIG_IKCONFIG), pero
# sigue omitida hasta comprobar en una compilacion que pasa las matrices de nivel 7.
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# WiFi
PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    libwifi-hal-ctrl \
    libwifi-hal-qcom \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/wifi/WCNSS_qcom_cfg.ini:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/WCNSS_qcom_cfg.ini

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml

# WiFi Firmware Symlinks
PRODUCT_PACKAGES += \
    firmware_wlan_mac.bin_symlink \
    firmware_WCNSS_qcom_cfg.ini_symlink

# Inherit from the proprietary files makefile.
$(call inherit-product, vendor/lenovo/J606F/J606F-vendor.mk)
