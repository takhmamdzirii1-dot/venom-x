#!/usr/bin/env python3
"""Bake a visually strong VENOM logo with edge flames into one animated WebP.
No asset loading per-frame in CSP; preserves sharp original branding.
"""
from pathlib import Path
from PIL import Image, ImageFilter, ImageChops, ImageDraw
import math, random

ASSETS = Path("assets")
W, H, N = 768, 258, 16
SOURCE = ASSETS / "venom_logo.webp"
OUT = ASSETS / "venom_fire_logo_v5.webp"
STILL = ASSETS / "venom_fire_logo_v5.png"
PREVIEW = ASSETS / "venom_fire_v5_preview.png"

logo = Image.open(SOURCE).convert("RGBA")
lw = 694
lh = round(lw * logo.height / logo.width)
logo = logo.resize((lw, lh), Image.Resampling.LANCZOS)
lx, ly = (W-lw)//2, max(18, (H-lh)//2)
logo_mask = Image.new("L", (W,H), 0)
logo_mask.paste(logo.getchannel("A"), (lx,ly))
logo_full = Image.new("RGBA",(W,H))
logo_full.alpha_composite(logo, (lx,ly))
# The edge locations are sampled from the actual supplied transparent art.
top = {}
for x in range(38,W-38,30):
    for y in range(ly, min(H,ly+lh)):
        if logo_mask.getpixel((x,y)) > 80:
            top[x]=y
            break

def tongue(draw, x, y, height, thick, phase, rgba):
    # soft curved feather-shaped flame, wide base and elegantly pointed tip.
    pts=[]
    for k in range(9):
        p=k/8
        z=y-height*p
        sway=(6+6*p)*math.sin(phase+3.3*p)+3*math.sin(phase*.8+7.7*p)
        radius=max(.1,thick*(1-p)**.82 * (.74+.2*math.sin(7*p+phase)))
        pts.append((x+sway-radius,z))
    for k in range(8,-1,-1):
        p=k/8
        z=y-height*p
        sway=(6+6*p)*math.sin(phase+3.3*p)+3*math.sin(phase*.8+7.7*p)
        radius=max(.1,thick*(1-p)**.82 * (.74+.2*math.sin(7*p+phase)))
        pts.append((x+sway+radius,z))
    draw.polygon(pts,fill=rgba)

frames=[]
rng=random.Random(624031)
flames=[]
for i,(x,y) in enumerate(top.items()):
    if x<48 or x>W-48:continue
    # At the center, keep the race HUD time readable; prioritize the wings.
    if 331 < x < 437 and y<60:continue
    flames.append((x,y+3,43+rng.random()*39,10+rng.random()*8,rng.random()*math.tau))
# Side flames rise around the logo silhouette, not under the virtual mirror.
for side in [0,1]:
    for i in range(5):
        x=(49+i*10) if side==0 else (W-49-i*10)
        y=112+i*10
        flames.append((x,y,38+i*5,9+rng.random()*4,rng.random()*math.tau))

blur1=logo_mask.filter(ImageFilter.GaussianBlur(15))
blur2=logo_mask.filter(ImageFilter.GaussianBlur(5))
rim=ImageChops.subtract(logo_mask.filter(ImageFilter.MaxFilter(7)),logo_mask)
def layer_color(rgb,alpha):
    layer=Image.new("RGBA",(W,H),(*rgb,0))
    layer.putalpha(alpha)
    return layer
for frame in range(N):
    tt=2*math.pi*frame/N
    glow_outer=blur1.point(lambda v,minv=0: min(158,round(v*.45)))
    glow_inner=blur2.point(lambda v: min(197,round(v*.63)))
    canvas=Image.new("RGBA",(W,H))
    canvas.alpha_composite(layer_color((219,20,7),glow_outer))
    canvas.alpha_composite(layer_color((255,66,14),glow_inner))

    fireglow=Image.new("RGBA",(W,H))
    gd=ImageDraw.Draw(fireglow,"RGBA")
    sharp=Image.new("RGBA",(W,H))
    sd=ImageDraw.Draw(sharp,"RGBA")
    for i,(x,y,height,thick,offset) in enumerate(flames):
        wave=math.sin(tt+offset)
        length=height*(.81+.19*wave)
        phi=tt+offset
        tongue(gd,x,y,length+8,thick*1.65,phi,(255,42,0,128))
        tongue(sd,x,y,length,thick,phi,(238,38,4,232))
        tongue(sd,x,y,length*.87,thick*.67,phi+.15,(255,115,5,215))
        tongue(sd,x,y,length*.63,thick*.35,phi+.08,(255,214,62,203))
    canvas.alpha_composite(fireglow.filter(ImageFilter.GaussianBlur(6)))
    canvas.alpha_composite(sharp)
    # Keep the original logo's letters, snake and red highlights crisp on top.
    canvas.alpha_composite(logo_full)
    rim_alpha=rim.point(lambda v: min(150,round(v*(.44+.13*math.sin(tt*2)))))
    canvas.alpha_composite(layer_color((255,80,24),rim_alpha))

    # Small premium sparks drift upwards away from the side wings.
    specks=Image.new("RGBA",(W,H))
    d=ImageDraw.Draw(specks,"RGBA")
    for j in range(15):
        side=(j%2)
        anchor=(75+j*12%140) if side==0 else (W-75-j*12%140)
        p=((frame/N)+j*.189)%1
        xx=anchor+5*math.sin(p*7+j)
        yy=135-p*104+(j%5)*6
        rad=.95+(.6 if j%3==0 else 0)
        d.ellipse((xx-rad,yy-rad,xx+rad,yy+rad),
                  fill=(255,146+6*(j%4),32,round(185*(1-p))))
    canvas.alpha_composite(specks)
    frames.append(canvas)

# Decode 16 distinct frames and preserve alpha. No GIF palette conversion.
frames[0].save(OUT,"WEBP",save_all=True,append_images=frames[1:],
    duration=95,loop=0,quality=89,method=6)
frames[0].save(STILL,"PNG",optimize=True)
# Visible preview against a bright sky tone similar to LA Canyons screenshot.
preview=Image.new("RGB",(W,H),(66,147,218))
preview.paste(frames[0],(0,0),frames[0])
preview.save(PREVIEW,"PNG",optimize=True)
with Image.open(OUT) as check:
    assert check.n_frames==N, check.n_frames
    assert check.size==(W,H)
assert OUT.stat().st_size < 2_000_000,OUT.stat().st_size
print("strong fire WebP",OUT.stat().st_size,"bytes / frames",N)
print("original art source",SOURCE,"logo at",lx,ly,"flames",len(flames))
