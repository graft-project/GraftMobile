#!/bin/bash

# Help
function help {
usage="$(basename "$0") [-h] [-s -b -o] -- program creates application dmg file with background image and ref link on Application directory.

where:
    -h  show this help text.
    -s  path to folder with .app. All files from this folder will be copied into dmg too.
    -o  output folder path. Script will save dmg file into this folder.
    -b  path to background image.
"
echo "$usage"
}

# Checks if parameter value isn't empty. If it is empty shows warning message and help.
function parameterValidation {
    if [ -z "$1" ]
    then
        echo "ERROR: $2"
        echo
        #show help and stop running script
        help
        exit -1
    fi
}

# Reading input parameters
while getopts hs:b:o: option
do
    case "${option}" in
        h) help
           exit ;;
        s) SRC_FOLDER=${OPTARG};;
        b) BACKGROUND_IMAGE_PATH=${OPTARG};;
        o) OUTPUT_DMG_DIR=${OPTARG};;
    esac
done

# Validate parameters
parameterValidation "$SRC_FOLDER" "Source folder path is needed. See -s parameter"
parameterValidation "$BACKGROUND_IMAGE_PATH" "Path to background image is needed. See -b parameter"
parameterValidation "$OUTPUT_DMG_DIR" "Path to output folder is needed. See -o parameter"


# Prepare DMG parameters
APP_FULL_NAME=`find $SRC_FOLDER -name '*.app' -maxdepth 1 | head -n 1 | sed "s/.*\///"`
APP_NAME=${APP_FULL_NAME%.*}
BG_IMG_NAME=$(basename "$BACKGROUND_IMAGE_PATH")
DMG_PATH="$OUTPUT_DMG_DIR/$APP_NAME.dmg"
VOLUME_NAME=$APP_NAME
MOUNT_DIR=/Volumes/"${VOLUME_NAME}"
DMG_TMP_PATH="$OUTPUT_DMG_DIR/temp.dmg"

echo "DMG file properties:"
echo "  Application Name: $APP_NAME"
echo "  Background Image Name: $BG_IMG_NAME"
echo "  DMG Name: $DMG_PATH"
echo "  Volume Name: $VOLUME_NAME"
echo "  Output directory: $OUTPUT_DMG_DIR"
echo ""


# Create output directory if needed
mkdir -p $OUTPUT_DMG_DIR

# Create the image
echo "Creating disk image..."
test -f "${DMG_PATH}" && rm -f "${DMG_PATH}"
ACTUAL_SIZE=`du -sm $SRC_FOLDER/ | awk '{print $1;}'`
DISK_IMAGE_SIZE=$(expr $ACTUAL_SIZE + 20)

if [ -f "$SRC_FOLDER/.DS_Store" ]; then
    echo "Deleting any .DS_Store in source folder"
    rm "$SRC_FOLDER/.DS_Store"
fi

hdiutil create -srcfolder "$SRC_FOLDER" -volname "${VOLUME_NAME}" -fs HFS+ -fsargs "-c c=64,a=16,e=16" -format UDRW -size ${DISK_IMAGE_SIZE} "${DMG_TMP_PATH}"

# Mount the image
echo "Mounting disk image..."
hdiutil attach -noverify -noautoopen "$DMG_TMP_PATH"

# Add a link to the Applications dir
echo "Add /Applications link..."
pushd "${MOUNT_DIR}"
ln -s /Applications
popd

# Add a background image
echo "Add Background image..."
mkdir "${MOUNT_DIR}/.background"
cp "$BACKGROUND_IMAGE_PATH" "${MOUNT_DIR}/.background/"

# tell the Finder to resize the window, set the background,
#  change the icon size, place the icons in the right position, etc.
echo "Update dmg view..."
echo '
on run
    tell application "Finder"
        tell disk "'${VOLUME_NAME}'"
        open
            set theXOrigin to 400
            set theYOrigin to 100
            set theWidth to 700
            set theHeight to 700
            
            set theBottomRightX to (theXOrigin + theWidth)
            set theBottomRightY to (theYOrigin + theHeight)

            tell container window
                set current view to icon view
                set toolbar visible to false
                set statusbar visible to false
                set the bounds to {theXOrigin, theYOrigin, theBottomRightX, theBottomRightY}
                set statusbar visible to false
                set position of every item to {theBottomRightX + 100, theYOrigin}
            end tell

            set opts to the icon view options of container window
            tell opts
                set icon size to 130
                set arrangement to not arranged
            end tell

            set background picture of opts to file ".background:'${BG_IMG_NAME}'"
            set position of item "'${APP_NAME}'.app" to {200, 480}
            set position of item "Applications" to {470, 480}
        close
        open
            update without registering applications
        end tell
        delay 5
    end tell
end run
' | osascript

# make sure it's not world writeable
echo "Fixing permissions..."
chmod -Rf go-w "${MOUNT_DIR}" &> /dev/null || true
echo "Done fixing permissions."

# make the top window open itself on mount:
echo "Blessing started"
bless --folder "${MOUNT_DIR}" --openfolder "${MOUNT_DIR}"
echo "Blessing finished"

sync
hdiutil detach "${MOUNT_DIR}"

# compress image
echo "Compressing disk image..."
hdiutil convert "${DMG_TMP_PATH}" -format UDZO -imagekey zlib-level=9 -o "${DMG_PATH}"
rm -f "${DMG_TMP_PATH}"

echo "DMG file is created"


