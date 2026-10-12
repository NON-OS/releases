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
| Network | Paravirtualized Network (virtio-net) |
| USB | USB 3.0 (xHCI) |
| Display | VMSVGA, 128 MB |

The two that matter most: EFI has to be on, and the disk has to be on SATA,
not the default IDE controller.

From a terminal:

```
VBoxManage createvm --name NONOS --ostype Other_64 --register
VBoxManage modifyvm NONOS --firmware efi --chipset ich9 --memory 4096 --cpus 2 \
  --nic1 nat --nictype1 virtio --usbxhci on --graphicscontroller vmsvga --vram 128
VBoxManage storagectl NONOS --name SATA --add sata --controller IntelAhci
VBoxManage storageattach NONOS --storagectl SATA --port 0 --type hdd --medium nonos.vdi
VBoxManage startvm NONOS
```

## Known issue in 0.9.2

NØNOS boots and runs in VirtualBox but doesn't get a network connection there
yet. It's being fixed. If you need the network now, use [QEMU](qemu.md).
