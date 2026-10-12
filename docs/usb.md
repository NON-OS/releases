# Booting from a USB stick

Write `nonos.img` to a stick of 1 GB or more. This erases the stick.

## Linux

Find the stick with `lsblk`, then:

```
sudo dd if=nonos.img of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `/dev/sdX` with your stick, not a partition like `/dev/sdX1`. Getting
this wrong overwrites the wrong disk.

## macOS

```
diskutil list
diskutil unmountDisk /dev/diskN
sudo dd if=nonos.img of=/dev/rdiskN bs=4m
```

## Windows

Use [Rufus](https://rufus.ie) or [balenaEtcher](https://etcher.balena.io) and
pick `nonos.img`.

## Booting

Restart, open the boot menu (often F12, F11 or Esc), and choose the stick in
UEFI mode. 0.9.2 hasn't been tested with Secure Boot on, so turn it off.

In 0.9.2 a stick boots as a live session: what you do isn't saved back to the
stick. To keep things, install NØNOS to a disk from the desktop.
