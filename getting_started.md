# Woosmap Geofencing SDK Cordova Plugin
This Cordova plugin extends the functionality offered by Woosmap Geofencing Mobile SDKs. Find more about Woosmap Geofencing SDK [here.](https://deploy-preview-386--developers-woosmap.netlify.app/products/geofencing-sdk/get-started/)

### Getting started
--- 
**Prepration of Mac/Windows for Cordova**
Before you begin make sure you have installed and setup Cordova on your machine. 
* [Installing Cordova on Mac](https://www.tomspencer.dev/blog/2017/05/29/a-guide-to-installing-cordova-on-your-mac/)
* [Installing Cordova on Windows](https://www.tomspencer.dev/blog/2017/05/30/a-guide-to-installing-cordova-on-windows-10/)

**Create your cordova app**
```
cordova create <folder_name> <package_name> <project_name>
cd <folder_name>
```

**Add platform**

If you are developing for iOS

```
cordova platform add ios@6.0.0
cordova plugin add cordova-plugin-add-swift-support --save
```

For Android
```
cordova plugin add cordova-plugin-androidx
cordova platform add android
```

**Add Woosmap Geofencing Cordova plugin to your project**

```
cordova plugin add https://github.com/sanginfolbs/wgs_geofencing_cordova_release.git
```


**Running plugin on Android platfrom**

**_Before running the app on Android platform you need to perform following steps._**

_**Configuring Github username and access token**_
Since the plugin uses Woosmap Geofencing SDK deployed on Github packages, you will need to create a Github access token and configure it in your dev environment. Please go through this [link](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to know about creating access tokens in Github. Make sure you have given `read-package` permission while creating the token.

Once you create your Github personal access token create two environment variables. Variable `GITHUB_USER` will contain your Github user id and variable `GITHUB_PERSONAL_ACCESS_TOKEN` will contain your Github personal access token. Check this [link](https://saralgyaan.com/posts/set-passwords-and-secret-keys-in-environment-variables-maclinuxwindows-python-quicktip/) to know how to set up environment variables on Windows and Mac. 

_**Download Firebase configuration file**_

Once you add `android` platform you will need download and place firebase configuration file in the appropriate folder. Follow steps given [here](https://support.google.com/firebase/answer/7015592?hl=en#zippy=%2Cin-this-article) to download your configuration file. Put the file in `platforms` -> `android` -> `app` folder.

Once you have done this, replace the www folder in your project with Example->www folder and build the project using following command

```
cordova build
```

**Adding testcase**
```
cordova plugin add cordova-plugin-test-framework
cordova plugin add ../WoosmapGeofencing/tests 
```
Change the start page in `config.xml` with `<content src="cdvtests/index.html" />` or add a link to `cdvtests/index.html` from within your app.

### Supported Platforms
--- 
* iOS
* Android

### Modules
---
* **Woosmap**: Woosmap contains methods to monitor location, POIs, regions and visits.
* **WoosmapDb**: contains methods to fetch POIs, regions and visits from the local device DB.

### Objects(Read Only)
---
* **Location**: Represents the location object.
* **POI**: Represents Point of Interest.
* **Region**: Represents a geographical region/geofence
* **Visit**: Represents a visit to a location/POI
* **ZOI**: Represents Zone of Interest.
* **Airship**: Contains custom data related to Airship implementation
