import plistlib
import os

def changeBuildApplePlist(pathToFile, majorV = 0, minorV = 0, buildV = 0):
    if os.path.isfile(pathToFile):
        plist = plistlib.readPlist(pathToFile)
        
        bundleShortVersion = str(majorV) + '.' + str(minorV)
        bundleVersion = str(majorV) + '.' + str(minorV) + '.' + str(buildV)
        
        plist["CFBundleShortVersionString"] = bundleShortVersion
        plist["CFBundleVersion"] = bundleVersion
        
        plistlib.writePlist(plist, pathToFile)
    else:
        print("You have specified a bad path to the *.plist file!")