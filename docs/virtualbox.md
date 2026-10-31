# Running NØNOS in VirtualBox

Tested with VirtualBox 7.2, on Linux. It needs a machine with VT-x or AMD-V, so not an
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
| Memory | 4096 MB, 2 CPUs, I/O APIC on |
| System | Enable EFI, chipset ICH9 |
| Storage | SATA (AHCI) controller, with nonos.vdi on it |
| Network | Intel PRO/1000 MT Desktop (82540EM) |
| USB | USB 3.0 (xHCI), USB tablet pointer |
| Display | VBoxVGA, 128 MB, EFI resolution 1920×1080 (below) |

The two that matter most: EFI has to be on, and the disk has to be on SATA,
not the default IDE controller.

From a terminal:

```
VBoxManage createvm --name NONOS --ostype Other_64 --register
VBoxManage modifyvm NONOS --firmware efi --chipset ich9 --memory 4096 --cpus 2 \
  --nic1 nat --nictype1 82540EM --usbxhci on --graphicscontroller vboxvga --vram 128 --ioapic on --mouse usbtablet
VBoxManage setextradata NONOS VBoxInternal2/EfiGraphicsResolution 1920x1080
VBoxManage storagectl NONOS --name SATA --add sata --controller IntelAhci
VBoxManage storageattach NONOS --storagectl SATA --port 0 --type hdd --medium nonos.vdi
VBoxManage startvm NONOS
```

## The resolution

With VBoxVGA, NØNOS draws on the firmware's framebuffer, at the size set by
`VBoxInternal2/EfiGraphicsResolution` (1920x1080 above). After changing it,
delete `NONOS.nvram` in the VM's folder once so the firmware forgets the mode
it saved. With VMSVGA, NØNOS's SVGA driver comes up at 1024×768.

## The network

0.9.3 drives the Intel 82540EM, the card VirtualBox calls Intel PRO/1000 MT
Desktop, so pick that one. Booted in VirtualBox 7.2 with the settings above,
the published 0.9.3 image reached its first-boot setup, took a DHCP address
(10.0.2.15) and connected out to the Nym and Anyone networks. On the desktop, the Terminal's
`ifconfig` showed `net0: inet 10.0.2.15/24`, and the Browser loaded pages over
the Nym mixnet. The run, with its
serial log, network trace and screenshot, is the
[`virtualbox` workflow](../.github/workflows/virtualbox.yml) of this repository;
run it on any release from the Actions tab.

0.9.2 had no network in VirtualBox.
