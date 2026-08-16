#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2020-2021 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
FDEVICE="ingres"
#set -o xtrace

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
   if [ -n "$chkdev" ]; then 
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
	export LC_ALL="C.UTF-8"
 	export ALLOW_MISSING_DEPENDENCIES=true
 	
 	#OFR build settings & info
 	# FOX_VANILLA_BUILD sengaja TIDAK di-hardcode di sini -- workflow CI yang menentukan
 	# ini secara eksplisit (hardcode FOX_VARIANT=HyperOS, fox_12.1 saja), supaya tidak ketiban aturan lokal ini.
	export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
	export TARGET_DEVICE_ALT="ingres"
	export FOX_RECOVERY_SYSTEM_PARTITION="/dev/block/mapper/system"
	export FOX_RECOVERY_VENDOR_PARTITION="/dev/block/mapper/vendor"
	export FOX_DELETE_INITD_ADDON=1
	export FOX_SETTINGS_ROOT_DIRECTORY="/persist/OFRP"

	#OFR display
	# OF_SCREEN_H: layar ingres 1080x2400 = rasio ~20:9, BUKAN 16:9 default OrangeFox (1920).
	# Rumus resmi (orangefox_build_vars.txt): <rasio_tinggi_basis_9>*120 -> 20*120 = 2400.
	# WAJIB di sini (vendorsetup.sh/script), BUKAN di BoardConfig.mk/.mk mana pun -- dikonfirmasi
	# dari wiki resmi OrangeFox: variabel OF_/FOX_ tidak diproses sama sekali kalau ditaruh di file .mk.
	export OF_SCREEN_H=2400

	#OFR binary files
	export FOX_REPLACE_BUSYBOX_PS=1
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_REPLACE_TOOLBOX_GETPROP=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_USE_SED_BINARY=1
	export FOX_USE_NANO_EDITOR=1
	
	#OTA
	export FOX_VIRTUAL_AB_DEVICE=1
	export FOX_DELETE_AROMAFM=1
	export FOX_ENABLE_APP_MANAGER=1

    # Maintainer (fallback build lokal -- workflow CI selalu override ini)
   	export OF_MAINTAINER=D2N

	# lunch dipanggil eksplisit oleh workflow CI (fox_12.1, sintaks lunch 2-part, hardcode),
	# jadi TIDAK di-auto-lunch di sini lagi -- itu bisa tumpang tindih dgn yang workflow lakukan sendiri.
	# Untuk build manual/lokal, jalankan lunch secara eksplisit sendiri setelah source file ini.
	# let's see what are our build VARs
	if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
  	   export | grep "FOX" >> $FOX_BUILD_LOG_FILE
  	   export | grep "OF_" >> $FOX_BUILD_LOG_FILE
   	   export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
  	   export | grep "TW_" >> $FOX_BUILD_LOG_FILE
 	fi
fi
#
