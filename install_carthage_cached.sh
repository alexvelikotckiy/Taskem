#!/bin/bash

PROJECT_NAME="Agenda"
PROJECT_CACHE="$HOME/Library/Caches/$PROJECT_NAME"

CARTHGE_CACHE_DIR="$PROJECT_CACHE/Carthage"
CARTHAGE_CACHE="$CARTHGE_CACHE_DIR/Build/"
CACHED_CARTFILE="$CARTHGE_CACHE_DIR/Cartfile.resolved"

CARTHAGE_DIR="Carthage/Build/"
CARTFILE="Cartfile.resolved"

function are_files_equal {
DIFF_RESULT=$(diff $1 $2)
DIFF_SIZE=${#DIFF_RESULT}
if [ $DIFF_SIZE -eq 0 ]; then
return 1
else
return 0
fi
}

if [ -e $CACHED_CARTFILE ]; then
if are_files_equal $CARTFILE $CACHED_CARTFILE ; then
NEED_BOOSTRAP=1
echo "Cached $CARTFILE was changed. Will run boostrap in any case."
else
NEED_BOOSTRAP=0
echo "Cached $CARTFILE was not changed. "
fi
else
NEED_BOOSTRAP=1
echo "Cached $CARTFILE is missing. Will run boostrap in any case."
fi

function bootstrap_carthage {
echo "Runing bootstrap"
carthage bootstrap --platform ios  --cache-builds
}

function bootstrap_carthage_if_required {
if [ $NEED_BOOSTRAP -eq 1 ]; then
bootstrap_carthage
fi
}

if [ ! -d "$CARTHAGE_DIR" ]; then
echo "Missing local dependencies"

if [ -d "$CARTHAGE_CACHE" ]; then
echo "Copying dependencies from cache..."
mkdir -pv "$CARTHAGE_DIR"
cp -r "$CARTHAGE_CACHE" "$CARTHAGE_DIR"
echo "Dependencies copied"
bootstrap_carthage_if_required
else
echo "Missing dependencies cache."
bootstrap_carthage
echo "Copying dependencies to cache..."
mkdir -pv "$CARTHAGE_CACHE"
cp -r "$CARTHAGE_DIR" "$CARTHAGE_CACHE"
echo "Dependencies copied"
fi
else
echo "Using local dependencies"
bootstrap_carthage_if_required
fi

echo "Caching $CARTFILE"
cp "$CARTFILE" "$CACHED_CARTFILE"

