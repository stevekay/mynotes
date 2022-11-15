Using get_iplayer

RHEL9

* enable epel (for mojolicious)
 
TODO

* enable rpmfusion (for ffmpeg)
```
$ sudo dnf install --nogpgcheck https://mirrors.rpmfusion.org/free/el/rpmfusion-free-release-$(rpm -E %rhel).noarch.rpm
```

* install dependencies
```
$ sudo yum install -y perl-Env perl-HTTP-Entity-Parser perl-HTTP-Cookies  perl-HTML-Parser perl-HTML-Element-Extended perl-LWP-Protocol-http10 perl-open perl-Unicode-Normalize perl-JSON-PP perl-XML-LibXML perl-LWP-Protocol-https perl-Time-Piece perl-Mojolicious ffmpeg
```

* download get_iplayer

```
$ git clone git@github.com:get-iplayer/get_iplayer.git
Cloning into 'get_iplayer'...
remote: Enumerating objects: 6117, done.
remote: Counting objects: 100% (230/230), done.
remote: Compressing objects: 100% (104/104), done.
remote: Total 6117 (delta 131), reused 211 (delta 126), pack-reused 5887
Receiving objects: 100% (6117/6117), 5.13 MiB | 933.00 KiB/s, done.
Resolving deltas: 100% (4099/4099), done.
```

* search for radio programmes
```
$ cd get_iplayer
$ ./get_iplayer --type=radio sorry
get_iplayer v3.30, Copyright (C) 2008-2010 Phil Lewis
  This program comes with ABSOLUTELY NO WARRANTY; for details use --warranty.
  This is free software, and you are welcome to redistribute it under certain
  conditions; use --conditions for details.



INFO: Indexing radio programmes (concurrent)
..........................................................................................................................................................................................................................................................................................................................................................................................
INFO: Added 15072 radio programmes to cache
Matches:
36451:  I'm Sorry I Haven't A Clue: Series 78 - Episode 1, BBC Radio 4, m001f52w
41682:  Sorry About Last Night - A Loft, BBC Radio 4 Extra, b00mzvfq
41683:  Sorry About Last Night - A Airport, BBC Radio 4 Extra, b00n4gmx
41684:  Sorry About Last Night - A Animal, BBC Radio 4 Extra, b00n8vry
INFO: 4 matching programmes
$
```

* download radio programme, convert to mp3
```
$ ./get_iplayer 'sorry.*clue' --type=radio --get --force --command-radio='ffmpeg -i "<filename>" -c:v copy -c:a libmp3lame -q:a 0 -y "<dir>/<fileprefix>.mp3"'
get_iplayer v3.30, Copyright (C) 2008-2010 Phil Lewis
  This program comes with ABSOLUTELY NO WARRANTY; for details use --warranty.
  This is free software, and you are welcome to redistribute it under certain
  conditions; use --conditions for details.


Matches:
36451:  I'm Sorry I Haven't A Clue: Series 78 - Episode 1, BBC Radio 4, m001f52w
INFO: 1 matching programmes

INFO: Downloading radio: 'I'm Sorry I Haven't A Clue: Series 78 - 01. Episode 1 (m001f52w) [original]'
INFO: Downloaded: 69.59 MB (00:28:00) @ 61.86 Mb/s (hlshigh1/bi) [audio]
INFO: Converting to M4A
WARNING: Required AtomicParsley utility not found - cannot tag M4A file
INFO: Running user command
ffmpeg version 5.1.2 Copyright (c) 2000-2022 the FFmpeg developers
  built with gcc 11 (GCC)
  configuration: --prefix=/usr --bindir=/usr/bin --datadir=/usr/share/ffmpeg --docdir=/usr/share/doc/ffmpeg --incdir=/usr/include/ffmpeg --libdir=/usr/lib64 --mandir=/usr/share/man --arch=x86_64 --optflags='-O2 -flto=auto -ffat-lto-objects -fexceptions -g -grecord-gcc-switches -pipe -Wall -Werror=format-security -Wp,-D_FORTIFY_SOURCE=2 -Wp,-D_GLIBCXX_ASSERTIONS -specs=/usr/lib/rpm/redhat/redhat-hardened-cc1 -fstack-protector-strong -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 -m64 -march=x86-64-v2 -mtune=generic -fasynchronous-unwind-tables -fstack-clash-protection -fcf-protection' --extra-ldflags='-Wl,-z,relro -Wl,--as-needed -Wl,-z,now -specs=/usr/lib/rpm/redhat/redhat-hardened-ld -specs=/usr/lib/rpm/redhat/redhat-annobin-cc1 ' --extra-cflags=' -I/usr/include/rav1e' --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libvo-amrwbenc --enable-version3 --enable-bzlib --enable-chromaprint --disable-crystalhd --enable-fontconfig --enable-gcrypt --enable-gnutls --enable-ladspa --enable-libaom --enable-libdav1d --enable-libass --enable-libbluray --enable-libbs2b --enable-libcdio --enable-libdrm --enable-libjack --enable-libfreetype --enable-libfribidi --enable-libgsm --enable-libilbc --enable-libmp3lame --enable-libmysofa --enable-nvenc --enable-openal --enable-opencl --enable-opengl --enable-libopenjpeg --enable-libopenmpt --enable-libopus --enable-libpulse --enable-librsvg --enable-librubberband --enable-libsmbclient --enable-version3 --enable-libsnappy --enable-libsoxr --enable-libspeex --enable-libsrt --enable-libssh --enable-libtesseract --enable-libtheora --enable-libtwolame --enable-libvorbis --enable-libv4l2 --enable-libvidstab --enable-libvmaf --enable-version3 --enable-vapoursynth --enable-libvpx --enable-libwebp --enable-libx264 --enable-libx265 --enable-libxvid --enable-libxml2 --enable-libzimg --enable-libzmq --enable-libzvbi --enable-avfilter --enable-libmodplug --enable-postproc --enable-pthreads --disable-static --enable-shared --enable-gpl --disable-debug --disable-stripping --shlibdir=/usr/lib64 --enable-lto --enable-libmfx --enable-runtime-cpudetect
  libavutil      57. 28.100 / 57. 28.100
  libavcodec     59. 37.100 / 59. 37.100
  libavformat    59. 27.100 / 59. 27.100
  libavdevice    59.  7.100 / 59.  7.100
  libavfilter     8. 44.100 /  8. 44.100
  libswscale      6.  7.100 /  6.  7.100
  libswresample   4.  7.100 /  4.  7.100
  libpostproc    56.  6.100 / 56.  6.100
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '/home/steve/iplayer/get_iplayer/Im_Sorry_I_Havent_A_Clue_Series_78_-_01._Episode_1_m001f52w_original.m4a':
  Metadata:
    major_brand     : M4A
    minor_version   : 512
    compatible_brands: M4A isomiso2
    encoder         : Lavf59.27.100
  Duration: 00:28:00.19, start: 0.000000, bitrate: 318 kb/s
  Stream #0:0[0x1](eng): Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 317 kb/s (default)
    Metadata:
      handler_name    : SoundHandler
      vendor_id       : [0][0][0][0]
Stream mapping:
  Stream #0:0 -> #0:0 (aac (native) -> mp3 (libmp3lame))
Press [q] to stop, [?] for help
Output #0, mp3, to '/home/steve/iplayer/get_iplayer/Im_Sorry_I_Havent_A_Clue_Series_78_-_01._Episode_1_m001f52w_original.mp3':
  Metadata:
    major_brand     : M4A
    minor_version   : 512
    compatible_brands: M4A isomiso2
    TSSE            : Lavf59.27.100
  Stream #0:0(eng): Audio: mp3, 48000 Hz, stereo, fltp (default)
    Metadata:
      handler_name    : SoundHandler
      vendor_id       : [0][0][0][0]
      encoder         : Lavc59.37.100 libmp3lame
size=   52488kB time=00:28:00.19 bitrate= 255.9kbits/s speed=25.7x
video:0kB audio:52487kB subtitle:0kB other streams:0kB global headers:0kB muxing overhead: 0.000625%
$
```

* list resulting files
```
$ file Im*
Im_Sorry_I_Havent_A_Clue_Series_78_-_01._Episode_1_m001f52w_original.m4a: ISO Media, Apple iTunes ALAC/AAC-LC (.M4A) Audio
Im_Sorry_I_Havent_A_Clue_Series_78_-_01._Episode_1_m001f52w_original.mp3: Audio file with ID3 version 2.4.0, contains:MPEG ADTS, layer III, v1, 64 kbps, 48 kHz, Stereo
$ ls -l Im*
-rw-r--r--. 1 steve steve 66972751 Nov 15 09:32 Im_Sorry_I_Havent_A_Clue_Series_78_-_01._Episode_1_m001f52w_original.m4a
-rw-r--r--. 1 steve steve 53747232 Nov 15 09:33 Im_Sorry_I_Havent_A_Clue_Series_78_-_01._Episode_1_m001f52w_original.mp3
$
```


