# NØNOS releases

Every NØNOS release, kept in one place: the images, their checksums, and the
public material you need to check them yourself.

The images are attached to each [GitHub release](https://github.com/NON-OS/releases/releases),
so they download from GitHub's CDN. The same files are served from
[nonos.software/download](https://nonos.software/download/). Source code lives in
[NON-OS/microkernel](https://github.com/NON-OS/microkernel).

## Latest: 0.9.2 (pre-release, 10 October 2026)

| File | Size | SHA-256 |
|---|---|---|
| [nonos.img](https://github.com/NON-OS/releases/releases/download/v0.9.2/nonos.img) | 995 MiB | `ae4998a180fbbd51f50f92fd6979aacf6528ed4e7cc608f62d20258a5b2bc9c8` |
| [nonos.iso](https://github.com/NON-OS/releases/releases/download/v0.9.2/nonos.iso) | 239 MiB | `604f5fda93cda0137c5ca613d3cf1ee8727724f1d2a95665748e523884001efa` |

BLAKE3:

```
6ccc049de2b5caae2b2f608135299975e74aac647a86fa73620d5a3a08c4b40c  nonos.img
fc841edaeb0c3abe1be60b4756aec51ab465a7507e1805d757e377dff7d49dae  nonos.iso
```

`nonos.img` is a raw GPT disk image, for a USB stick or a virtual machine.
`nonos.iso` is the same system as a UEFI-bootable ISO.

What changed in 0.9.2 is in the
[release notes](https://github.com/NON-OS/microkernel/releases/tag/v0.9.2).

## Checking a download

Download the image and its sum files from the same release, then:

```
sha256sum -c IMAGE-SHA256SUMS
b3sum -c IMAGE-BLAKE3SUMS
```

On macOS, `shasum -a 256 -c IMAGE-SHA256SUMS` does the first; `b3sum` comes
from Homebrew (`brew install b3sum`).

Both hashes have to say `OK`. If one doesn't, the file is damaged or isn't
ours; download it again from here and don't boot it.

The kernel, the loader and every capsule in the image are rebuilt by CI from
the public tag, and they come out the same bytes on Linux and macOS. CI's
bundle carries signed build provenance, which GitHub can check for you:

```
gh release download v0.9.2 --repo NON-OS/microkernel --pattern nonos-release-bundle.tar.gz
gh attestation verify nonos-release-bundle.tar.gz --repo NON-OS/microkernel
```

Or rebuild it yourself with Nix and compare:

```
nix build github:NON-OS/microkernel/v0.9.2#standard
```

## Running it in a virtual machine

NØNOS is x86_64 and boots with UEFI. These are the setups we boot it with.

### QEMU (the one we test on)

```
cp /usr/share/OVMF/OVMF_VARS_4M.fd nonos-vars.fd
qemu-system-x86_64 -machine q35 -accel kvm -cpu host -m 4G -smp 4 \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE_4M.fd \
  -drive if=pflash,format=raw,file=nonos-vars.fd \
  -drive file=nonos.img,format=raw,if=virtio \
  -nic user,model=virtio-net-pci -device qemu-xhci -device usb-tablet -device virtio-rng-pci
```

Boot the disk image, not the ISO: from the ISO NØNOS has no disk to keep
Linux programs on. The firmware paths are Debian and Ubuntu's (`apt install qemu-system-x86 ovmf`).
On Arch, install `edk2-ovmf` and use `/usr/share/edk2/x64/OVMF_CODE.4m.fd` and
`OVMF_VARS.4m.fd`. On macOS, `-accel hvf` on Intel Macs. Apple Silicon Macs
can only emulate x86: leave out `-accel` and `-cpu host`, expect it to be slow,
or use [UTM](https://mac.getutm.app) with "Emulate" and x86_64.

### VirtualBox 7

Tested with VirtualBox 7.2.6. Use the ISO, or turn the disk image into a VDI:

```
VBoxManage convertfromraw nonos.img nonos.vdi --format VDI
```

Then create the machine. In the GUI:

1. Type **Other**, version **Other/Unknown (64-bit)**. 4096 MB of memory, 2 CPUs.
2. System: tick **Enable EFI**, chipset **ICH9**.
3. Storage: remove the IDE controller, add a **SATA (AHCI)** controller, and put
   `nonos.vdi` or `nonos.iso` on it.
4. Network: adapter type **Paravirtualized Network (virtio-net)** (see the known issue below).
5. USB: **USB 3.0 (xHCI)**.
6. Display: **VMSVGA**, 128 MB.

Or the same from a terminal:

```
VBoxManage createvm --name NONOS --ostype Other_64 --register
VBoxManage modifyvm NONOS --firmware efi --chipset ich9 --memory 4096 --cpus 2 \
  --nic1 nat --nictype1 virtio --usbxhci on --graphicscontroller vmsvga --vram 128
VBoxManage storagectl NONOS --name SATA --add sata --controller IntelAhci
VBoxManage storageattach NONOS --storagectl SATA --port 0 --type hdd --medium nonos.vdi
VBoxManage startvm NONOS
```

For the ISO, attach it with `--type dvddrive --medium nonos.iso` instead.

Two things that stop it from booting: leaving EFI off, and keeping the default
IDE controller.

Known issue in 0.9.2: NØNOS boots and runs in VirtualBox, but it doesn't get
a network connection there yet, with either the virtio-net or the Intel
PRO/1000 adapter. Networking works in QEMU. The fix is in progress for the
next release; until then, use QEMU if you need the network.

VirtualBox needs hardware virtualization (VT-x or AMD-V), so it can't run
NØNOS on an Apple Silicon Mac or inside most cloud VPSes.

## What's in each version folder

Each `vX.Y.Z/` folder holds the small, public half of a release, so it can be
read and diffed in git:

- `IMAGE-SHA256SUMS`, `IMAGE-BLAKE3SUMS`: the hashes of the image and the ISO.
- `attestation/kernel.zk_trailer.bin`, `attestation/bootloader.trailer`: the
  STARK attestation the kernel and the loader carry.
- `attestation/kernel.approval`: the kernel's approval record.
- `attestation/nonos-release.json`: the release record the seal wrote, with the
  hash of every component.
- `attestation/trust-policy/`: the public trust roots the system checks against,
  among them the one STARK policy root over every capsule. No private key is
  in this repository, and none ever will be.

## All versions

| Version | Date | Notes |
|---|---|---|
| [0.9.2](v0.9.2/) | 10 October 2026 | Pre-release. Replaces the 0.9.2 tag of 3 September. |

## Reporting a problem

A checksum that doesn't match, a file that won't boot, or anything that looks
tampered with: open an issue here, or write to us through
[nonos.software](https://nonos.software).
