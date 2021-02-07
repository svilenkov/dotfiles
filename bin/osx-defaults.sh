#!/bin/bash

set -e

# prevents creation of .DS_Store files
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

# Fast show/hide of Dock
defaults write com.apple.dock autohide-time-modifier -int 0

# Disable back/forward navigation via swipe left/right
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE

# Add a quit option to Finder
defaults write com.apple.finder QuitMenuItem -bool true

# Fast key repeats (defaults are soooooo slow)
defaults write -g InitialKeyRepat -int 15

killall Dock
killall Finder
