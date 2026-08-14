#
# Copyright (C) 2022 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Device path for OEM device tree
# NOTE: this must be defined here (not just in BoardConfig.mk) because product
# config files like this one are evaluated *before* BoardConfig.mk during the
# build, so $(DEVICE_PATH) below would otherwise be empty and fox_ingres.mk
# would silently fail to be inherited.
DEVICE_PATH := device/xiaomi/ingres

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common twrp stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from ingres device
$(call inherit-product, device/xiaomi/ingres/device.mk)

# Inherit any OrangeFox-specific settings
$(call inherit-product-if-exists, $(DEVICE_PATH)/fox_$(PRODUCT_RELEASE_NAME).mk)

PRODUCT_DEVICE := ingres
PRODUCT_NAME := twrp_ingres
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Redmi K50Gaming
PRODUCT_MANUFACTURER := xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

