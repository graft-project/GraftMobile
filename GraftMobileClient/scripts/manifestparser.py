from xml.dom import minidom

def setVersionCode(majorVersion = 0, minorVersion = 0, buildVersion = 0):    
    if minorVersion >= 10 and minorVersion <= 99:
        lMinorVersion = minorVersion
    elif minorVersion < 10:
        lMinorVersion = "{}{}".format(0, minorVersion)
    else:
        lMinorVersion = 0

    if buildVersion >= 10 and buildVersion <= 99:
        lBuildVersion = buildVersion
    elif buildVersion < 10:
        lBuildVersion = "{}{}".format(0, buildVersion)
    else:
        lBuildVersion = 0

    return "{}{}{}".format(majorVersion, lMinorVersion, lBuildVersion)

def changeVersion(pathToFile, majorVersion = 0, minorVersion = 0, buildVersion = 0):
    root = minidom.parse(pathToFile)

    versionName = "{}.{}.{}".format(majorVersion, minorVersion, buildVersion)
    versionCode = setVersionCode(majorVersion, minorVersion, buildVersion)

    print(root.documentElement.getAttribute("android:versionName"))
    print(root.documentElement.getAttribute('android:versionCode'))

    root.documentElement.setAttribute("android:versionName", versionName)
    root.documentElement.setAttribute("android:versionCode", versionCode)

    print(root.documentElement.getAttribute("android:versionName"))
    print(root.documentElement.getAttribute('android:versionCode'))

    file = open("C:\\Users\\dmytr\\Desktop\\Python\\android.xml", "wb")
    print(root.toxml().encode('utf-8'))
    file.write(root.toxml().encode('utf-8'))
    file.close()