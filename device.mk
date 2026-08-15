#
# Copyright (C) 2022 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/xiaomi/ingres

# Inherit from common AOSP config
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

# Enable project quotas and casefolding for emulated storage without sdcardfs
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Installs gsi keys into ramdisk, to boot a GSI with verified boot.
$(call inherit-product-if-exists, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)
# PERBAIKAN Android 16 (dikonfirmasi dari build.log): build/make/target/product/gsi_keys.mk
# sudah di-rename upstream jadi developer_gsi_keys.mk oleh Google (restrukturisasi luas per
# Jun 2025) -- dikonfirmasi dari DUA reference tree resmi OrangeFox (sm8450-common fox_14.1
# maupun fox_16.0), keduanya sudah pakai nama baru ini. Diarahkan langsung ke nama baru
# (bukan sekadar di-skip) supaya fungsinya (gsi keys di ramdisk) tetap terpasang. Tetap
# pakai inherit-product-if-exists sebagai jaring pengaman kalau ada manifest yang belum
# ikut berubah. Semua inherit-product LAIN di file ini dan di twrp_ingres.mk (base.mk,
# emulated_storage.mk, virtual_ab_ota.mk, core_64_bit.mk, full_base_telephony.mk) sudah
# dicek satu-satu terhadap listing resmi android.googlesource.com/platform/build dan masih
# ada semua -- tidak disentuh.

# Default Android A/B configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)

# A/B related packages
ENABLE_AB := true
ENABLE_VIRTUAL_AB := true

PRODUCT_PACKAGES += update_engine \
    update_engine_client \
    update_verifier \
    android.hardware.boot@1.2-impl-qti \
    android.hardware.boot@1.2-impl-qti.recovery \
    android.hardware.boot@1.2-service

PRODUCT_PACKAGES += \
  update_engine_sideload

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

# Board
BOARD_SHIPPING_API_LEVEL := 31
# PERBAIKAN release-config (dikonfirmasi dari build.log fox_14.1): begitu manifest pakai
# sistem release-config (lunch dengan "ap2a", dst -- lihat build/make/core/board_config.mk),
# BOARD_API_LEVEL DILARANG diset manual kalau RELEASE_BOARD_API_LEVEL sudah terisi --
# errornya persis "BOARD_API_LEVEL must not set manully". Dibungkus ifndef supaya baris ini
# HANYA aktif di manifest lama tanpa release-config (mis. fox_12.1); di manifest baru
# otomatis tidak aktif dan nilainya diambil alih sistem dari release config.
ifndef RELEASE_BOARD_API_LEVEL
BOARD_API_LEVEL := 31
endif
PRODUCT_SHIPPING_API_LEVEL := 31
SHIPPING_API_LEVEL := 31

# Boot/kernel Console enabled
TARGET_CONSOLE_ENABLED := true

# Build
BUILD_BROKEN_DUP_RULES := true
RELAX_USES_LIBRARY_CHECK := true

# Crypto
PRODUCT_PACKAGES += \
    qcom_decrypt \
    qcom_decrypt_fbe

# Dynamic partition Handling
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Fastbootd
PRODUCT_PACKAGES += \
	android.hardware.fastboot@1.0-impl-mock \
	android.hardware.fastboot@1.0-impl-mock.recovery \
	fastbootd

# f2fs utilities
PRODUCT_PACKAGES += \
    sg_write_buffer \
    f2fs_io \
    check_f2fs

# Health HAL
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-service \
    android.hardware.health@2.1-impl

# Platform
TARGET_BOARD_PLATFORM := taro
TARGET_BOOTLOADER_BOARD_NAME := taro
QCOM_BOARD_PLATFORMS += taro

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH)

# Suppot to compile recovery without msm headers
TARGET_HAS_GENERIC_KERNEL_HEADERS := true

# Userdata checkpoint
PRODUCT_PACKAGES += \
    checkpoint_gc
