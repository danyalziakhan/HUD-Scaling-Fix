# HUD Scaling Fix

A Witcher 3 mod that lets the HUD reach the edges of screens that aren't 16:9.

The game lays out its HUD inside a 16:9 frame. On wider or taller screens that
frame sits in the middle with empty space around it. The game does have
vertical and horizontal frame scale settings, but its Rescale HUD screen only
goes up to 1, which can shrink the frame but never stretch it. This mod puts
both values in the Mods menu with a range of 1 to 2.25.

## Presets

Vanilla (16:9), 16:10, 21:9, 32:9, 4:3, 5:3 and 5:4.

The values are calculated from the aspect ratio rather than tuned by eye, so the
HUD lands exactly on the screen edges. 21:9 is exact for 3440x1440 and 32:9 for
3840x1080 and 5120x1440.

For any other resolution, divide the width by the height. If that number is
above 1.7778, set the horizontal scale to it divided by 1.7778. If it is below,
set the vertical scale to 1.7778 divided by it. A 2560x1080 screen, for example,
needs a horizontal scale of 1.3333.

## How it works

The mod started as a single config file and now also ships a few scripts.

Six HUD modules (buffs, item info, controls feedback, console and both horse
bars) placed themselves with hardcoded offsets that only lined up at a scale of
1. Those overrides are removed, so they follow the same scaling as the rest of
the HUD. At a scale of 1 their position is unchanged.

The options menu now applies a preset or slider change as soon as you leave the
page, instead of needing a second trip through the menu.

Using the game's own Rescale HUD screen still resets both values to 1, so pick
your preset again afterwards.

## Installing

Copy the contents into your Witcher 3 folder, then add modHUDScalingFix.xml to
dx12filelist.txt (or dx11filelist.txt). Menu Filelist Updater will do that part
for you.

The scripts change ingameMenu.ws and six hudModule files, so run Script Merger
if another mod edits any of them. Adjustable FOV also changes ingameMenu.ws and
the two merge cleanly.

MIT licensed.
