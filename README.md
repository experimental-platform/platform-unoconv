# Platform Unoconv [![Build Status](https://travis-ci.org/experimental-platform/platform-unoconv.svg?branch=development)](https://travis-ci.org/experimental-platform/platform-unoconv)

**[Unoconv](https://github.com/dagwieers/unoconv) as a docker service**

## Custom fonts

You can expand the set of supported fonts by adding the `.ttf` files to `/usr/local/share/fonts`. The recommended way
to do this is to:

  1. Do a docker volume mount, i.e. `--volume /data/fonts:/usr/local/share/fonts`
  2. Restart the listener service when the fonts directory changes to force a font cache reload

You can list the available fonts by running `fc-list`, so for example by doing:

  docker run -it --rm unoconv fc-list

## Runit/Monit

When this image launches, it starts [runit](http://smarden.org/runit/) with two services:
  
  * monit
  * unoconv (in listener mode)

The reason for this non-standard setup is that unoconv, or more specifically libreoffice, starts to spike at 100% CPU
usage when it's fed the right kind of "broken" file (and these cases are not too uncommon). Since short-term spikes
in CPU usage should still be allowed for converting large files, we need to monitor the resource consumption over time
and only act upon it when the CPU usage remains high for a while. Hence, monit is keeping an eye on the unoconv
listener.