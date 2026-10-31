# Running NØNOS in VirtualBox

Tested with VirtualBox 7.2. It needs a machine with VT-x or AMD-V, so not an
Apple silicon Mac and not most cloud servers.

## The disk

Turn the image into a VirtualBox disk:

```
VBoxManage convertfromraw nonos.img nonos.vdi --format VDI
```

You can also attach `nonos.iso` as an optical drive instead.

## The machine

| Setting | Value |
|---|---|
| Type | Other, Other/Unknown (64-bit) |
| Memory | 4096 MB, 2 CPUs |
| System | Enable EFI, chipset ICH9 |
| Storage | SATA (AHCI) controller, with nonos.vdi on it |
| Network | Intel PRO/1000 MT Desktop (82540EM) |
| USB | USB 3.0 (xHCI) |
| Display | VMSVGA, 128 MB |

The two that matter most: EFI has to be on, and the disk has to be on SATA,
not the default IDE controller.

From a terminal:

```
VBoxManage createvm --name NONOS --ostype Other_64 --register
VBoxManage modifyvm NONOS --firmware efi --chipset ich9 --memory 4096 --cpus 2 \
  --nic1 nat --nictype1 82540EM --usbxhci on --graphicscontroller vmsvga --vram 128
VBoxManage storagectl NONOS --name SATA --add sata --controller IntelAhci
VBoxManage storageattach NONOS --storagectl SATA --port 0 --type hdd --medium nonos.vdi
VBoxManage startvm NONOS
```

## The network

0.9.3 drives the Intel 82540EM, the card VirtualBox calls Intel PRO/1000 MT
Desktop, so pick that one. The sealed 0.9.3 image, on that card and a SATA
disk, took a DHCP address and reached the Nym and Anyone networks; that run was
under QEMU's model of the same card, and a run in VirtualBox itself is still to
come. If the network doesn't come up, use [QEMU](qemu.md) and tell us in an
[issue](https://github.com/NON-OS/releases/issues).

0.9.2 had no network in VirtualBox.
