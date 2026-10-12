# NØNOS releases

Every NØNOS build we ship, with the checksums and the public trust material
to check it against. The source lives in [NON-OS/microkernel](https://github.com/NON-OS/microkernel).

## 0.9.2

Pre-release, 10 October 2026.

| | |
|---|---|
| Disk image | [nonos.img](https://github.com/NON-OS/releases/releases/download/v0.9.2/nonos.img) · 995 MiB |
| ISO | [nonos.iso](https://github.com/NON-OS/releases/releases/download/v0.9.2/nonos.iso) · 239 MiB |
| Checksums | [IMAGE-SHA256SUMS](https://github.com/NON-OS/releases/releases/download/v0.9.2/IMAGE-SHA256SUMS) · [IMAGE-BLAKE3SUMS](https://github.com/NON-OS/releases/releases/download/v0.9.2/IMAGE-BLAKE3SUMS) |

Hashes, the attestation and what's in this version: [v0.9.2/](v0.9.2/)

## Getting started

```
curl -LO https://github.com/NON-OS/releases/releases/download/v0.9.2/nonos.img
curl -LO https://github.com/NON-OS/releases/releases/download/v0.9.2/IMAGE-SHA256SUMS
curl -LO https://raw.githubusercontent.com/NON-OS/releases/main/scripts/verify.sh
sh verify.sh
```

Then pick how you want to run it:

- [QEMU](docs/qemu.md), on Linux or macOS. What we test on.
- [VirtualBox](docs/virtualbox.md), on Windows or Linux.
- [A USB stick](docs/usb.md), on a real machine.

More on checking a download, and rebuilding it yourself: [docs/verify.md](docs/verify.md)

## Versions

| Version | Date | |
|---|---|---|
| [0.9.2](v0.9.2/) | 10 October 2026 | pre-release |

## Something wrong?

A checksum that doesn't match, an image that won't boot, anything that looks
tampered with: [open an issue](https://github.com/NON-OS/releases/issues).
