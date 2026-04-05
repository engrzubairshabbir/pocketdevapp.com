"""Regenerate tab favicons from assets/pocketdev-logo-512.png (run after logo updates)."""
from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent
SRC = ROOT / "assets" / "pocketdev-logo-512.png"
OUT = ROOT / "assets"


def main() -> None:
    img = Image.open(SRC).convert("RGBA")
    w, h = img.size
    # Square crop on upper art (robot + dome); omit most of bottom wordmark for 16px clarity
    side = int(min(w, h) * 0.66)
    left = (w - side) // 2
    top = int(h * 0.02)
    cropped = img.crop((left, top, left + side, top + side))

    resample = Image.Resampling.LANCZOS
    fav16 = cropped.resize((16, 16), resample)
    fav32 = cropped.resize((32, 32), resample)
    fav16.save(OUT / "favicon-16.png", optimize=True)
    fav32.save(OUT / "favicon-32.png", optimize=True)

    fav48 = cropped.resize((48, 48), resample)
    # ICO: largest frame first so Pillow embeds all appended sizes
    fav48.save(
        OUT / "favicon.ico",
        format="ICO",
        append_images=[fav32, fav16],
    )


if __name__ == "__main__":
    main()
