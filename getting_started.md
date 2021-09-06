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

**Adding test cases**
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

### Check and request permissions
---
Before initializing the SDK it is required that you request for required location permissions. 

To check if the location permissions are granted by the user call `getPermissionsStatus` method. 

```
cordova.plugins.Woosmap.getPermissionsStatus(success, errorCallback);
var success = function(status) {
   console.log(status);
};
var errorCallback = function(error) {
   alert('message: ' + error.message);
};
```

Parameter status will be a string, one of:
* `GRANTED_BACKGROUND` : User has granted location access even when app is not running in the foreground
* `GRANTED_FOREGROUND` : Location access is granted only while user is using the app
* `DENIED`: Location access is denied.

**_Please note_**: Plugin will not work as expected if location access is denied. 

**Requesting location access**
To request location access call `requestPermissions` method of the plugin. This will result in displaying location access permission dialoag. This method accepts a boolean parameter `isBackground`. If this parameter is set to true then plugin will ask for background location access. Code snippet below asks for background location access.

```
cordova.plugins.Woosmap.requestPermissions(true, success, errorCallback);
var success = function() {
   console.log("success");
};
var errorCallback = function(error) {
   alert('message: ' + error.message);
};

```

### Initializing the plugin
---

Plugin can be initialized by simply calling `initialize` method. 

```
var woosmapSettings = {
    privateKeyWoosmapAPI: "<<WOOSMAP_KEY>>",
    trackingProfile: "liveTracking"
};
cordova.plugins.Woosmap.initialize(woosmapSettings, onSuccess, onError);
var onSuccess = function() {
    console.log("success");
};
var onError = function(error) {
    alert('message: ' + error.message);
};
```

Both configuration options `privateKeyWoosmapAPI` and `trackingProfile` are optional. You can also initialize the plugin by passing null configuration.

```
cordova.plugins.Woosmap.initialize(null, onSuccess, onError);
```

You also set the Woosmap API key later by calling `setWoosmapApiKey` method.

```
cordova.plugins.Woosmap.setWoosmapApiKey(<privateKeyWoosmapAPI>, onSuccess, onError);
```

### Tracking
---

Once you have initialized the plugin and the user has authorized location permissions, you can start tracking the user’s location.

To start tracking, call:
```
cordova.plugins.WoosmapGeofencing.startTracking('liveTracking', onSuccess, onError);
```

To stop tracking, call:
```
cordova.plugins.WoosmapGeofencing.stopTracking(onSuccess, onError);
```

Method `startTracking` accepts only following tracking profiles

* **liveTracking**
* **passiveTracking**
* **visitsTracking**

### Tracking profile properties
---

| Property | liveTracking | passiveTracking | visitsTracking
| ----------- | ----------- | ----------- | ----------- |
| trackingEnable | true | true | true
| foregroundLocationServiceEnable | true | false | false
| modeHighFrequencyLocation | true | false | false
| visitEnable | false | false | true
| classificationEnable | false | false | true
| minDurationVisitDisplay | null | null | 300
| radiusDetectionClassifiedZOI | null | null | 50
| distanceDetectionThresholdVisits | null | null | 25
| currentLocationTimeFilter | 0 | 0 | 0
| currentLocationDistanceFilter | 0 | 0 | 0
| accuracyFilter | 100 | 100 | 100
| searchAPIEnable | false | false | false
| searchAPICreationRegionEnable | false | false | false
| searchAPITimeFilter | 0 | 0 | 0
| searchAPIDistanceFilter | 0 | 0 | 0
| distanceAPIEnable | false | false | false
| modeDistance | null | null | null
| outOfTimeDelay | 300 | 300 | 300
| DOUBLEOfDayDataDuration | 30 | 30 | 30

### Listening to events
---











 
