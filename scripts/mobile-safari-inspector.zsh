#!/bin/sh
#
# Configure Mobile Safari on the Simulator allow remote debugging of web pages
# and open safari to view the inspector.
#

pid=$(ps x | egrep "MobileSafari|Web.app" | grep -v grep | awk '{ print $1 }')

if [ "$pid" == "" ]; then
  echo "Safari.app must be running in the Simulator to enable the remote inspector."
else

  cat <<EOS | gdb -quiet > /dev/null
    attach $pid
    p (void *)[WebView _enableRemoteInspector]
    detach
EOS

  osascript <<EOS > /dev/null 2>&1
    tell application "Safari"
      activate
      do JavaScript "window.open('http://localhost:9999')" in document 1
    end tell
EOS

fi