# NØNOS 0.9.2

Pre-release, 10 October 2026. Built from
[NON-OS/microkernel@v0.9.2](https://github.com/NON-OS/microkernel/tree/v0.9.2).
What changed: [release notes](https://github.com/NON-OS/microkernel/releases/tag/v0.9.2).

## Images

| File | Size | SHA-256 |
|---|---|---|
| [nonos.img](https://github.com/NON-OS/releases/releases/download/v0.9.2/nonos.img) | 1043148800 | `ae4998a180fbbd51f50f92fd6979aacf6528ed4e7cc608f62d20258a5b2bc9c8` |
| [nonos.iso](https://github.com/NON-OS/releases/releases/download/v0.9.2/nonos.iso) | 250777600 | `604f5fda93cda0137c5ca613d3cf1ee8727724f1d2a95665748e523884001efa` |

| File | BLAKE3 |
|---|---|
| nonos.img | `6ccc049de2b5caae2b2f608135299975e74aac647a86fa73620d5a3a08c4b40c` |
| nonos.iso | `fc841edaeb0c3abe1be60b4756aec51ab465a7507e1805d757e377dff7d49dae` |

## Attestation

[`attestation/`](attestation/) holds the public side of the release, so it can
be read and diffed:

| | |
|---|---|
| `kernel.zk_trailer.bin` | the kernel's STARK attestation |
| `bootloader.trailer` | the loader's |
| `kernel.approval` | the kernel's approval record |
| `nonos-release.json` | every component and its hash, as the seal wrote it |
| `trust-policy/` | the roots the system checks against, including the STARK policy root over every capsule |

`attestation/SHA256SUMS` and `attestation/BLAKE3SUMS` cover every file in it.
There are no private keys here.

## Known issues

- No network in VirtualBox yet. QEMU and real hardware are fine.
- Not tested with Secure Boot on yet; turn it off.
- Booted from a USB stick it runs as a live session and saves nothing back to the stick.
