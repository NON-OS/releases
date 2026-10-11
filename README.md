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
