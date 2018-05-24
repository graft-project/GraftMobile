from xml.dom import minidom

def setVersionCode(majorVersion = 0, minorVersion = 0, buildVersion = 0):    
    lMinorVersion = 0
    if minorVersion >= 10 and minorVersion <= 99:
        lMinorVersion = minorVersion
    elif minorVersion < 10:
        lMinorVersion = "0{}".format(minorVersion)

    lBuildVersion = 0
    if buildVersion >= 10 and buildVersion <= 99:
        lBuildVersion = buildVersion
    elif buildVersion < 10:
        lBuildVersion = "0{}".format(buildVersion)

    return "{}{}{}".format(majorVersion, lMinorVersion, lBuildVersion)

def changeVersion(pathToFile, majorVersion = 0, minorVersion = 0, buildVersion = 0):
    root = minidom.parse(pathToFile)

    versionName = "{}.{}.{}".format(majorVersion, minorVersion, buildVersion)
    versionCode = setVersionCode(majorVersion, minorVersion, buildVersion)

    root.documentElement.setAttribute("android:versionName", versionName)
    root.documentElement.setAttribute("android:versionCode", versionCode)

    with open(pathToFile, "wb") as file:
        file.write(root.toxml().encode('utf-8'))
        file.close()
