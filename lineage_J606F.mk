#
# Copyright (C) 2022-2023 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
# Tablet solo Wi-Fi: full_base (sin telefonia), como gta4lwifi.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# Inherit from J606F device
$(call inherit-product, device/lenovo/J606F/device.mk)

# Inherit some common Lineage stuff.
$(call inherit-product, vendor/lineage/config/common_full_tablet_wifionly.mk)

# Perfil opcional de memoria para comparar con la base; desactivado por defecto.
$(call inherit-product, device/lenovo/J606F/configs/yaap-memory.mk)

PRODUCT_NAME := lineage_J606F
PRODUCT_DEVICE := J606F
PRODUCT_MANUFACTURER := LENOVO
PRODUCT_BRAND := Lenovo
PRODUCT_MODEL := Lenovo TB-J606F

PRODUCT_GMS_CLIENTID_BASE := android-lenovo

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="J606F-user 11 RKQ1.210303.002 S320383_240603_ROW release-keys" \
    BuildFingerprint=Lenovo/LenovoTB-J606F_EEA/J606F:11/RKQ1.210303.002/S320383_240603_ROW:user/release-keys \
    DeviceName=J606F \
    DeviceProduct=LenovoTB-J606F_EEA \
    SystemName=LenovoTB-J606F_EEA \
    SystemDevice=J606F
