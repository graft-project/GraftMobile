import re

def changeVersion(pathToFile, majorVersion = 0, minorVersion = 0, buildVersion = 0):
    with open(pathToFile, "r+") as file:
        data = file.read()

        FILEVERSION = "FILEVERSION {},{},{}".format(majorVersion, minorVersion, buildVersion)
        PRODUCTVERSION = "PRODUCTVERSION {},{},{}".format(majorVersion, minorVersion, buildVersion)
        VALUE_FILEVERSION = "VALUE \"FileVersion\", \"{}.{}.{}\"".format(majorVersion, minorVersion, buildVersion)
        VALUE_PRODUCTVERSION = "VALUE \"ProductVersion\", \"{}.{}.{}\"".format(majorVersion, minorVersion, buildVersion)
        
    
        data = data.replace(re.search(r'FILEVERSION \d{1,2},\d{1,2},\d{1,2}', data)[0], FILEVERSION, 1)
        data = data.replace(re.search(r'PRODUCTVERSION \d{1,2},\d{1,2},\d{1,2}', data)[0], PRODUCTVERSION, 1)
        data = data.replace(re.search(r'VALUE \"FileVersion\", \"\d{1,2}.\d{1,2}.\d{1,2}\"', data)[0], VALUE_FILEVERSION, 1)
        data = data.replace(re.search(r'VALUE \"ProductVersion\", \"\d{1,2}.\d{1,2}.\d{1,2}\"', data)[0], VALUE_PRODUCTVERSION, 1)
        
        file.seek(0)
        file.write(data)
        file.close()
