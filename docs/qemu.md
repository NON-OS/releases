# Running NØNOS in QEMU

QEMU is what we develop and test on. Boot the disk image, not the ISO: from
the ISO, NØNOS has nowhere to keep Linux programs.

## Install

| | |
|---|---|
| Debian, Ubuntu | `sudo apt install qemu-system-x86 ovmf` |
| Arch | `sudo pacman -S qemu-desktop edk2-ovmf` |
| Fedora | `sudo dnf install qemu-system-x86 edk2-ovmf` |
| macOS | `brew install qemu` |

## Run

[`scripts/run-qemu.sh`](../scripts/run-qemu.sh) finds the firmware and picks
the fastest accelerator your machine has:

```
sh run-qemu.sh nonos.img
```

Or the command it runs, on Debian and Ubuntu:

```
cp /usr/share/OVMF/OVMF_VARS_4M.fd nonos-vars.fd
qemu-system-x86_64 -machine q35 -accel kvm -cpu host -m 4G -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
  -drive if=pflash,format=raw,file=nonos-vars.fd \
  -drive file=nonos.img,format=raw,if=virtio \
  -nic user,model=virtio-net-pci \
  -device qemu-xhci -device usb-tablet -device virtio-rng-pci -vga std
```

## Notes

- Apple silicon Macs can only emulate x86, so it runs but slowly.
  [UTM](https://mac.getutm.app) with "Emulate" and x86_64 works too.
- Networking works out of the box with `-nic user`.
