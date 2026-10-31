# NØNOS 0.9.3

Released 31 October 2026. Built from
[NON-OS/microkernel@79b321165a](https://github.com/NON-OS/microkernel/tree/79b321165a):
the source the build receipt names, `540286d1fb`, plus the trust set the seal
produced. What changed: [release notes](https://nonos.software/docs/kernel/release/0.9.3/).

## Images

| File | Size | SHA-256 |
|---|---|---|
| [nonos.img](https://github.com/NON-OS/releases/releases/download/v0.9.3/nonos.img) | 1043148800 | `fbde7306a9a7cf1b7032501f49011af5ee88d162efb4ad884b14bba6d8446332` |
| [nonos.iso](https://github.com/NON-OS/releases/releases/download/v0.9.3/nonos.iso) | 311777280 | `1a08418f58bf1c8a92a7094abcfc8833be91f5f3ef74e675640eb61c58ca5a4c` |

| File | BLAKE3 |
|---|---|
| nonos.img | `0f8772de3bbb0e1803617bb31e1394228f8df2607e1bd30fbfc3c5723c608003` |
| nonos.iso | `16ea4595c850fe13a5c0bd0d11722e05558c4bc4728aa8a8eb79317943bf2a7f` |

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
| `trust-policy/` | the roots the system checks against, including the STARK policy root over all 165 capsules |

`attestation/SHA256SUMS` and `attestation/BLAKE3SUMS` cover every file in it.
There are no private keys here.

The receipt reads `"dirty": true`: the seal writes the trust set into the tree
before it writes the receipt, and that set is committed afterwards as
`79b321165a`. 0.9.2's receipt reads the same way.

## Take it apart

Every file here can be opened with ordinary tools. The walk-through, 45
commands with what each output shows, is
[TAKING-NONOS-0.9.3-APART.md](https://nonos.software/releases/v0.9.3/TAKING-NONOS-0.9.3-APART.md).

## Known issues

- Not tested with Secure Boot on; turn it off.
- A Linux app's home is held in memory and is gone at power off.
- On a machine with no TPM, "Create a wallet" fails with "the keyring did not
  answer".
- Only the RTL8821CE has run on a real Wi-Fi card. The other Wi-Fi drivers
  have run only against a modelled device.

The full list is in the [release notes](https://nonos.software/docs/kernel/release/0.9.3-known-issues/).
