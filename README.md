scripts
======

### bkrn

Utilities for building kernel.

### cnv

Utilities for convenient media convertion.

Dependencies:
- `media-gfx/imagemagick`
- `media-video/ffmpeg x264 vpx fdk`
- `sys-process/parallel`

`ffmpeg` requires `media-libs/fdk-aac FraunhoferFDK` license.

### dominant-color

Returns dominant color of supplied image.

### eject-device

Performs all the nasty stuff of autosuspending USB, spinning down the drive and
unbinding USB device.

Dependencies:
- `sys-fs/udev`
- `sys-apps/hdparm`

### expenses

Poor fellow's calculator.

Dependencies:
- `app-office/gnumeric`
- `app-crypt/gnupg`
- `sys-apps/coreutils`

### invert

Poor fellow's night-mode.

Dependencies:
- `x11-misc/compton`
- `x11-apps/xprop`

### jira

CLI for JIRA.

Dependencies:
- `python3`
- `jira`
- `jsonpath-rw`

### memo

Memorize staff? No more!

Dependencies:
- `app-crypt/gnupg`
- `sys-apps/coreutils`
- `x11-misc/xclip` is optional
