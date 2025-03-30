#!/bin/sh
#exporting the sway sock env
export SWAYSOCK=$(ls /run/user/1000/sway-ipc.1000.*.sock 2>/dev/null | head -n 1)
exec /sbin/nwg-dock -d -nolauncher -hd 0  #launching the dock

