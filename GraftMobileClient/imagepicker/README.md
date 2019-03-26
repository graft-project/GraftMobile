# QtTeam Image Picker Project

**Platforms:** *Android*, *iOS*.<br />
**Library build/release:** *Qt 5.9.7*.<br />
**Architecture:** *android_armv7*, *android_x86*, *ios*.<br />

> *[Click here for more information for Image Cropping Library for Android.](https://github.com/ArthurHub/Android-Image-Cropper)*

---

## Android

### Binaries Build Environment Configuration
| Title        | Version [Android] | Version [iOS] |
| :----------: | :---------------: | :-----------: |
| Qt           | 5.9.7             |  5.9.7        |
| Qt Creator   | 4.5.1             |  4.8.0        |
| Platform API | android-28        |  LLVM version 9.0.0 (clang-900.0.38) |
| SDK          | 26.1.1            |  -            |
| JDK          | 1.8.0_191         |  -            |
| NDK          | 15.2.4            |  -            |

> P.S. Wasn't implemented native call back which handling android permission system for **Qt versions less than 5.10.0**

### Add to *AndroidManifest.xml*:

    <activity android:name="com.theartofdev.edmodo.cropper.CropImageActivity" android:theme="@style/Theme.AppCompat.Light.DarkActionBar">
    </activity>

    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

    <provider android:name="android.support.v4.content.FileProvider" android:authorities="${applicationId}.provider" android:exported="false" android:grantUriPermissions="true">
        <meta-data android:name="android.support.FILE_PROVIDER_PATHS" android:resource="@xml/provider_paths"/>
    </provider>

### File provider

Also, you have to create **provider_paths.xml** file in **res/xml** folder. Content of those file must be next:

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-path name="external_files" path="."/>
</paths>
```

### Add to *build.gradle*:
    dependencies {
        ...
        compile 'com.theartofdev.edmodo:android-image-cropper:2.5.+'
    }

> P.S. You can use specific version of the library.

## iOS

### Add to *Info.plist*:

    <key>NSCameraUsageDescription</key>
    <string>Add the description of the usage of this feature.</string>

    key>NSPhotoLibraryUsageDescription</key>
    <string>Add the description of the usage of this feature.</string>
