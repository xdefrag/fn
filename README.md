# fn
Almost zero configuration script for your multimedia keys: adjust brightness, keyboard leds and volume by simple commands. I wrote it for mac, but it must work anywhere if you change class paths that suited for your configuration.

# Installation
Not hard. Throw in PATH and you are done.
```bash
$ chmod +x fn.sh
$ sudo cp fn.sh /usr/local/bin/fn
$ fn help
```

# But it doesn't work!
Yep.

# Udev
First of let's give permissions to adjust backlight and leds. Create ```/etc/udev/rules.d/99-permissions.rules``` or something like that with content:
```
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chgrp <insert-your-group-here> /sys/class/backlight/%k/brightness"
ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"

ACTION=="add", SUBSYSTEM=="leds", KERNEL=="smc::kbd_backlight", RUN+="/bin/chgrp <insert-your-group-here> /sys/class/leds/%k/brightness"
ACTION=="add", SUBSYSTEM=="leds", KERNEL=="smc::kbd_backlight", RUN+="/bin/chmod g+w /sys/class/leds/%k/brightness"
```
Replace ```<insert-your-group-here>``` with desired group for managing brightness.

More info: https://wiki.archlinux.org/index.php/Backlight#ACPI
 
 # Keys
 I use [xbindkeys](https://wiki.archlinux.org/index.php/Xbindkeys) tool for mapping, but any other will do. Config example:
 ```
"fn backlight -300"
  XF86MonBrightnessDown

"fn backlight +300"
  XF86MonBrightnessUp

"fn kbd -51"
  XF86KbdBrightnessDown

"fn kbd +51"
  XF86KbdBrightnessUp

"fn sound 0"
  XF86AudioMute
  
"fn sound -10"
  XF86AudioLowerVolume

"fn sound +10"
  XF86AudioRaiseVolume
 ```

And that's all! You're ready to start smashing those multimedia buttons for amusing people around with your superior features.
