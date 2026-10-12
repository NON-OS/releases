#!/bin/sh
# Check downloaded NØNOS images against the sums published with them.
# Run it in the folder that holds the image and the two sum files.
set -eu

sha() {
	if command -v sha256sum >/dev/null 2>&1; then sha256sum "$@"; else shasum -a 256 "$@"; fi
}

[ -f IMAGE-SHA256SUMS ] || { echo "IMAGE-SHA256SUMS is not in this folder"; exit 1; }

checked=0
while read -r sum file; do
	[ -f "$file" ] || continue
	got=$(sha "$file" | cut -d' ' -f1)
	if [ "$got" = "$sum" ]; then
		echo "sha256  ok    $file"
	else
		echo "sha256  WRONG $file"
		exit 1
	fi
	checked=$((checked + 1))
done < IMAGE-SHA256SUMS

[ "$checked" -gt 0 ] || { echo "no image from IMAGE-SHA256SUMS is in this folder"; exit 1; }

if [ -f IMAGE-BLAKE3SUMS ] && command -v b3sum >/dev/null 2>&1; then
	while read -r sum file; do
		[ -f "$file" ] || continue
		got=$(b3sum "$file" | cut -d' ' -f1)
		if [ "$got" = "$sum" ]; then
			echo "blake3  ok    $file"
		else
			echo "blake3  WRONG $file"
			exit 1
		fi
	done < IMAGE-BLAKE3SUMS
else
	echo "blake3  skipped (install b3sum to check it too)"
fi
