#!/bin/bash

BPATH=/mnt/ram/kernel-build
BKPATH=/var/kernel-bak

prepare() {
	mount /mnt/ram
	mkdir -p $BPATH
	chmod 1777 $BPATH
	mkdir -p $BKPATH
	chmod 1777 $BKPATH
}

build() {
	if [ ! -d "$BPATH" ] || [ ! -d "$BKPATH" ]; then
		echo "Do \"bkrn prepare\" before run."
		exit
	fi
	cd /usr/src/linux
	if [ ! -f "$BPATH/.config" ]; then
		if [ -f "$BKPATH/.config" ]; then
			cp $BKPATH/.config $BPATH
		else
			echo "There is no kernel .config in neither $BPATH nor $BKPATH !"
			exit
		fi
	fi
	make mrproper
	make O=$BPATH silentoldconfig
	make O=$BPATH menuconfig
	make O=$BPATH modules_prepare
	make O=$BPATH -j8
	if [ $? -ne 0 ]; then
		echo "Build failed!"
		exit
	fi
	emerge --ask @module-rebuild
	cp $BPATH/.config $BKPATH/.config-bak-$(date +%F)
}

initramfs() {
	rm /var/tmp/genkernel/init*
	genkernel --kerneldir=$BPATH --kernel-config=$BPATH/.config initramfs
	if [ $? -ne 0 ]; then
		echo "Initramfs creation failed!"
		exit
	fi
}

install() {
	cd /usr/src/linux
	make O=$BPATH modules_install
	mount /mnt/efi
	cp $BPATH/arch/x86/boot/bzImage /mnt/efi/efi/boot/bootx64.efi
	cp /var/tmp/genkernel/init* /mnt/efi/efi/boot/initramfs.img
	if [ $? -eq 0 ]; then
		echo "EFI stubbed!"
	fi
}

backup() {
	cp $BPATH/.config $BKPATH
	cp $BPATH/arch/x86/boot/bzImage $BKPATH/bootx64.efi
	cp /var/tmp/genkernel/init* $BKPATH/initramfs.img
	if [ $? -eq 0 ]; then
		echo "Backup made!"
	fi
}

restore() {
	mount /mnt/efi
	cp $BKPATH/bootx64.efi /mnt/efi/efi/boot
	cp $BKPATH/initramfs.img /mnt/efi/efi/boot
	if [ $? -eq 0 ]; then
		echo "EFI restored!"
	fi
}

if [ "$1" == "" ]; then
	build
else
	$1
fi
