import re

def changeVersion(pathToFile, majorVersion = 0, minorVersion = 0, buildVersion = 0):
    with open(pathToFile, "r+") as file:
        data = file.read()

        MAJOR_VERSION = "DEFINES += MAJOR_VERSION={}".format(majorVersion)
        MINOR_VERSION = "DEFINES += MINOR_VERSION={}".format(minorVersion)
        BUILD_VERSION = "DEFINES += BUILD_VERSION={}".format(buildVersion)
    
        data = data.replace(re.search(r'DEFINES \+= MAJOR_VERSION=\d{1,2}', data)[0], MAJOR_VERSION, 1)
        data = data.replace(re.search(r'DEFINES \+= MINOR_VERSION=\d{1,2}', data)[0], MINOR_VERSION, 1)
        data = data.replace(re.search(r'DEFINES \+= BUILD_VERSION=\d{1,2}', data)[0], BUILD_VERSION, 1)
        
        file.seek(0)
        file.write(data)
        file.close()
