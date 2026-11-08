# NØNOS 0.9.3.5

Released 8 November 2026. Built from
[NON-OS/microkernel@b3dd1fa37c](https://github.com/NON-OS/microkernel/tree/b3dd1fa37c):
the source the build receipt names, `b9c19ac940`, plus the trust set the seal
produced. What changed: [release notes](https://nonos.software/docs/kernel/release/0.9.3.5/).

0.9.3.5 is a beta.

## Images

| File | Size | SHA-256 |
|---|---|---|
| [nonos.img](https://github.com/NON-OS/releases/releases/download/v0.9.3.5/nonos.img) | 1043148800 | `689208557db66b4ea36bff5ce155218fd71b3272b971c17c695b0a73f7f9a805` |
| [nonos.iso](https://github.com/NON-OS/releases/releases/download/v0.9.3.5/nonos.iso) | 313700352 | `18e8963918bc4ee637a5499aab6b5bc82ec3bf4797a68f3816d125af7b3077e4` |

| File | BLAKE3 |
|---|---|
| nonos.img | `1be6dd0288a215c2ccec28df21b23282816df40d817f6419903e96cd19075fed` |
| nonos.iso | `ad38352deffaa60de58afb72e9f694c6d36b98ba74a3f2482c8d472d81fea0e7` |

The same files, with the kernel and loader binaries, are on
[nonos.software/download](https://nonos.software/download/).

## Attestation

[`attestation/`](attestation/) holds the public side of the release, so it can
be read and diffed:

| | |
|---|---|
| `kernel.zk_trailer.bin` | the kernel's STARK attestation |
| `bootloader.trailer` | the loader's |
| `kernel.approval` | the kernel's approval record |
| `nonos-release.json` | every component and its hash, as the seal wrote it |
| `build-receipt.json` | the source commit, the toolchain and the image hashes the build produced |
| `trust-policy/` | the roots the system checks against |

`attestation/SHA256SUMS` and `attestation/BLAKE3SUMS` cover every file in it.
There are no private keys here.

The receipt reads `"dirty": true`: the seal writes the trust set into the tree
before it writes the receipt, and that set is committed afterwards as
`b3dd1fa37c`. 0.9.3's and 0.9.2's receipts read the same way.

## Check it yourself

How to rerun the Lean, extraction, Verus and Kani checks, with every tool and
pin: [Reproduce the proofs](https://nonos.software/docs/kernel/build/reproduce-the-proofs/).
A walk-through of the 0.9.3 release with ordinary tools, which applies to the
same kind of files, is
[TAKING-NONOS-0.9.3-APART.md](https://nonos.software/releases/v0.9.3/TAKING-NONOS-0.9.3-APART.md).

## Known issues

What 0.9.3.5 does not do yet is in the
[release notes](https://nonos.software/docs/kernel/release/0.9.3.5/).
