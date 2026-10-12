#!/bin/sh
# Boot nonos.img in QEMU with UEFI firmware, on Linux or macOS.
#   ./run-qemu.sh [path/to/nonos.img]
set -eu

img=${1:-nonos.img}
[ -f "$img" ] || { echo "can't find $img"; exit 1; }

code=""
vars=""
for dir in /usr/share/OVMF /usr/share/edk2/x64 /usr/share/edk2/ovmf /usr/share/qemu \
           /opt/homebrew/share/qemu /usr/local/share/qemu; do
	for c in OVMF_CODE_4M.fd OVMF_CODE.4m.fd OVMF_CODE.fd edk2-x86_64-code.fd; do
		[ -z "$code" ] && [ -f "$dir/$c" ] && code="$dir/$c"
	done
	for v in OVMF_VARS_4M.fd OVMF_VARS.4m.fd OVMF_VARS.fd edk2-i386-vars.fd; do
		[ -z "$vars" ] && [ -f "$dir/$v" ] && vars="$dir/$v"
	done
done
[ -n "$code" ] || { echo "no UEFI firmware found: install ovmf (Debian, Ubuntu), edk2-ovmf (Arch, Fedora) or qemu (Homebrew)"; exit 1; }

state=${XDG_STATE_HOME:-$HOME/.local/state}/nonos
mkdir -p "$state"
[ -f "$state/vars.fd" ] || if [ -n "$vars" ]; then cp "$vars" "$state/vars.fd"; else dd if=/dev/zero of="$state/vars.fd" bs=1M count=4 2>/dev/null; fi
chmod u+w "$state/vars.fd"

if [ -w /dev/kvm ]; then
	accel="-accel kvm -cpu host"
elif [ "$(uname -s)" = Darwin ] && [ "$(uname -m)" = x86_64 ]; then
	accel="-accel hvf -cpu host"
else
	accel="-accel tcg -cpu max"
	echo "no hardware acceleration here, so this will be slow"
fi

exec qemu-system-x86_64 -machine q35 $accel -m 4G -smp 4 \
	-drive if=pflash,format=raw,readonly=on,file="$code" \
	-drive if=pflash,format=raw,file="$state/vars.fd" \
	-drive file="$img",format=raw,if=virtio \
	-nic user,model=virtio-net-pci \
	-device qemu-xhci -device usb-tablet -device virtio-rng-pci \
	-vga std
