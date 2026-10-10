#!/usr/bin/env python3
"""Convert verified GitHub sprite atlas into CSP-friendly RGBA and animated WebP."""
from PIL import Image, ImageEnhance
from pathlib import Path

src = Path("assets/venom_flames_atlas_v2.png")
out_png = Path("assets/venom_flames_rgba_v3.png")
out_webp = Path("assets/venom_flames_loop_v3.webp")
atlas = Image.open(src).convert("RGBA")
assert atlas.size == (1024, 246), f"unexpected atlas size: {atlas.size}"
# Retain independent transparent tongues while eliminating solid base near y=82.
frames = []
for i in range(12):
    x = (i % 4) * 256
    y = (i // 4) * 82
    frame = atlas.crop((x, y, x + 256, y + 70))
    r, g, b, a = frame.split()
    # Boost pale low-alpha tongues but preserve natural falloff and transparent edges.
    a = a.point(lambda n: min(255, round(n * 1.9)))
    # Feather the bottom 18 px to remove the horizontal strip visible
    # against Virtual Mirror; let individual flame tips remain above.
    for row in range(52, 70):
        attenuation = max(0.0, (69-row)/17.0)**1.5
        line = a.crop((0, row, 256, row+1)).point(
            lambda n: min(255, round(n*attenuation)))
        a.paste(line, (0, row))
    frame.putalpha(a)
    frames.append(frame)
# Fixed-size 4-by-3 RGBA atlas for clients without animated WebP playback.
out = Image.new("RGBA", (1024, 210), (0, 0, 0, 0))
for i, frame in enumerate(frames):
    out.alpha_composite(frame, dest=((i % 4) * 256, (i // 4) * 70))
out.save(out_png, format="PNG", optimize=True)
# CSP GIFPlayer can decode animated WEBP in addition to GIF; alpha is supported.
frames[0].save(
    out_webp, format="WEBP", save_all=True, append_images=frames[1:],
    duration=100, loop=0, quality=84, method=6,
)
# Verify formats and loop state before publishing.
assert Image.open(out_png).mode == "RGBA"
with Image.open(out_webp) as chk:
    assert chk.format == "WEBP" and chk.n_frames == 12 and chk.size == (256,70)
print(f"RGBA sprite atlas: {out_png.stat().st_size} bytes")
print(f"Animated WEBP: {out_webp.stat().st_size} bytes")
