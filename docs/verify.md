# Checking a download

Every release publishes two sums for each image, SHA-256 and BLAKE3. Both have
to match before you boot it.

## The quick way

Put the image and its sum files in one folder and run
[`scripts/verify.sh`](../scripts/verify.sh) there:

```
sh verify.sh
```

```
sha256  ok    nonos.img
blake3  ok    nonos.img
```

It checks whichever images from the release are in the folder, and stops at
the first one that doesn't match.

## By hand

```
sha256sum -c IMAGE-SHA256SUMS --ignore-missing
b3sum -c IMAGE-BLAKE3SUMS
```

On macOS: `shasum -a 256 -c IMAGE-SHA256SUMS`. `b3sum` is in Homebrew and in
most Linux distributions.

## Further than the hashes

Rebuild it and compare the bytes yourself. 0.9.3 was built from
`79b321165a`:

```
nix build github:NON-OS/microkernel/79b321165a#standard
```

The hashes a rebuild has to match are in
[`v0.9.3/attestation/build-receipt.json`](../v0.9.3/attestation/build-receipt.json).

Every file of the release can also be opened with ordinary tools; the 45-command
walk-through is [TAKING-NONOS-0.9.3-APART.md](https://nonos.software/releases/v0.9.3/TAKING-NONOS-0.9.3-APART.md).

For 0.9.2, CI built the kernel, loader and capsules from the public tag, and
GitHub keeps a signed record of that build:

```
gh release download v0.9.2 --repo NON-OS/microkernel --pattern nonos-release-bundle.tar.gz
gh attestation verify nonos-release-bundle.tar.gz --repo NON-OS/microkernel
nix build github:NON-OS/microkernel/v0.9.2#standard
```
