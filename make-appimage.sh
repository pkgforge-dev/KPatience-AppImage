#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q kpat | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/kpat.png
export DESKTOP=/usr/share/applications/org.kde.kpat.desktop
export STARTUPWMCLASS=org.kde.kpat
export DEPLOY_PULSE=1

# Deploy dependencies
quick-sharun /usr/bin/kpat /usr/share/kpat /usr/share/knsrcfiles /usr/share/config.kcfg /usr/lib/libKirigami*.so* /usr/share/carddecks

echo 'ANYLINUX_DO_NOT_LOAD_LIBS=libpipewire-0.3.so*:${ANYLINUX_DO_NOT_LOAD_LIBS}' >> ./AppDir/.env

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
