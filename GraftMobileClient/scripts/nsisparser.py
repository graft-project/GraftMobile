import re

def changeVersion(pathToFile, majorVersion = 0, minorVersion = 0, buildVersion = 0):
    with open(pathToFile, "r") as file:
        data = file.read()
    file.close()

    with open(pathToFile, "w") as file:
        VERSIONMAJOR = "!define VERSIONMAJOR {}".format(majorVersion)
        VERSIONMINOR = "!define VERSIONMINOR {}".format(minorVersion)
        VERSIONBUILD = "!define VERSIONBUILD {}".format(buildVersion)
        VERSION = "!define VERSION \"{}.{}.{}\"".format(majorVersion, minorVersion, buildVersion)
    
        data = data.replace(re.search(r'!define VERSIONMAJOR \d', data)[0], VERSIONMAJOR, 1)
        data = data.replace(re.search(r'!define VERSIONMINOR \d', data)[0], VERSIONMINOR, 1)
        data = data.replace(re.search(r'!define VERSIONBUILD \d', data)[0], VERSIONBUILD, 1)
        data = data.replace(re.search(r'!define VERSION \"\d\.\d\.\d\"', data)[0], VERSION, 1)
        
        file.write(data)
    
    file.close()