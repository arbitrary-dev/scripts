scripts
=======

### bkrn-\*

Utilities for building kernel.

### cnv

Utilities for convenient media convertion.

Dependencies:
- `media-gfx/imagemagick`
- `media-video/ffmpeg x264 vpx fdk`
- `sys-process/parallel`

`ffmpeg` requires `media-libs/fdk-aac FraunhoferFDK` license.

### deepl

CLI for [DeepL translator](https://deepl.com/translator).

Uses "Too many requests" API.

Dependencies:
- `app-misc/jq`
- `net-misc/curl`

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

Env variables required:
- `JIRA_USER`
- `JIRA_PASS`
- `JIRA_DEF_PROJECT`
- `JIRA_URL`

Dependencies:
- `python3`
- `python-dateutil`
- `jira`
- `jsonpath-rw`

### meminfo

Stats for system memory + swap.

### memo

Memorize stuff? No more!

Dependencies:
- `app-crypt/gnupg`
- `sys-apps/coreutils`
- `x11-misc/xclip` is optional

### mus

CLI wrapper around the actual player, to ease every day struggle in playing a
song.

Dependencies:
- `app-shells/zsh`
- `media-video/mpv`
- `sys-apps/util-linux` for `column`

### mutate

Sorts up that messed musical collection at last.

Dependencies:
- `python3`
- `mutagen`
- `prompt_toolkit`

### smb

Utility to use Samba sharing instance.

### weather-gismeteo [➛](weather-gismeteo)

Ask <b2b@gismeteo.ru> for a token to access Gismeteo API.

### weather-latvia [➛](weather-latvia)

Latvian weather sans map:  
<https://videscentrs.lvgmc.lv/karte>

Dependencies:
- `app-misc/jq`
- `app-shells/zsh`
- `net-misc/curl`
