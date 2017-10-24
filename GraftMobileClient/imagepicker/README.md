# QtTeam Image Picker Project

**Platforms:** *Windows*, *Linux*, *MacOS*, *Android*, *iOS*<br />

---

## Android

### Add to AndroidManifest.xml:

	<activity android:name="com.theartofdev.edmodo.cropper.CropImageActivity" android:theme="@style/Theme.AppCompat.Light.DarkActionBar"/>
	<!-- optional (needed if default theme has no action bar) -->

	<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

### Add to build.gradle:
	dependencies {
	    ...
	    compile 'com.theartofdev.edmodo:android-image-cropper:2.5.+' 
	}
	
> *P.S: you can use specific version of the library*