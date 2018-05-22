import plistlib
import os

def changeVersion(pathToFile, majorVersion = 0, minorVersion = 0, buildVersion = 0):
    if os.path.isfile(pathToFile):
        plist = plistlib.readPlist(pathToFile)
        
        bundleShortVersion = "{}.{}".format(majorVersion, minorVersion)
        bundleVersion = "{}.{}.{}".format(majorVersion, minorVersion, buildVersion)
        
        plist["CFBundleShortVersionString"] = bundleShortVersion
        plist["CFBundleVersion"] = bundleVersion
        
        plistlib.writePlist(plist, pathToFile)
    else:
        print("You have specified a bad path to the *.plist file!")
        