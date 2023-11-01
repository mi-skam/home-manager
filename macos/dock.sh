#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/System/Applications/Utilities/Terminal.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
dockutil --no-restart --add "/Applications/Arc.app"
dockutil --no-restart --add "/Applications/UTM.app"
dockutil --no-restart --add "/System/Applications/Mail.app"
dockutil --no-restart --add "/System/Applications/Calendar.app"
dockutil --no-restart --add "/System/Applications/Books.app"
dockutil --no-restart --add "/Applications/Reminders.app"
dockutil --no-restart --add "/Applications/Spotify.app"
dockutil --no-restart --add "/Applications/Tidal.app"

killall Dock
