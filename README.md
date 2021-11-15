![woosmap](https://static.intercomassets.com/avatars/4420093/square_128/apple-icon-180x180-1602843866.png?1602843866)
# Woosmap Geofencing SDK Cordova Plugin
This Cordova plugin extends the functionality offered by the Woosmap Geofencing Mobile SDKs. Find more about the Woosmap Geofencing SDK [here.](https://developers.woosmap.com/products/geofencing-sdk/get-started/)

### Getting started
--- 
**Preparation of Mac/Windows for Cordova**
Before you begin, make sure you have installed and setup Cordova on your machine. 
* [Installing Cordova on Mac](https://www.tomspencer.dev/blog/2017/05/29/a-guide-to-installing-cordova-on-your-mac/)
* [Installing Cordova on Windows](https://www.tomspencer.dev/blog/2017/05/30/a-guide-to-installing-cordova-on-windows-10/)

**Create your cordova app**
```
cordova create <folder_name> <package_name> <project_name>
cd <folder_name>
```

**Adding the platform**

For iOS

```
cordova platform add ios@6.0.0
cordova plugin add cordova-plugin-add-swift-support --save
```

For Android
```
cordova plugin add cordova-plugin-androidx
cordova platform add android
```

**Add the Woosmap Geofencing Cordova plugin to your project**

```
cordova plugin add @woosmap/cordova-plugin-geofencing --link
```


## Running the plugin on the Android platform

---

Once you have done this build and run the project using following command:

```
cordova build
cordova run <android>/<ios>
```

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
* **Location**: Represents the location object
* **POI**: Represents Point of Interest
* **Region**: Represents a geographical region/geofence
* **Visit**: Represents a visit to a location/POI
* **ZOI**: Represents Zone of Interest
* **Airship**: Contains custom data related to Airship implementation
* **MarketingCloud**: Contains custom data related to third party marketing cloud implementation

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
* `DENIED`: Location access is denied

**_Please note_**: Plugin will not work as expected if location access is denied. 

**Requesting location access**
To request location access call `requestPermissions` method of the plugin. This will result in displaying location access permission dialog. This method accepts a boolean parameter `isBackground`. If this parameter is set to true, then plugin will ask for background location access. Code snippet below asks for background location access.

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

You can also set the Woosmap API key later by calling `setWoosmapApiKey` method.

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
| searchAPIEnable | false | true | false
| searchAPICreationRegionEnable | false | true | false
| searchAPITimeFilter | 0 | 0 | 0
| searchAPIDistanceFilter | 0 | 0 | 0
| distanceAPIEnable | false | false | false
| modeDistance | null | null | null
| outOfTimeDelay | 300 | 300 | 300
| DOUBLEOfDayDataDuration | 30 | 30 | 30

### Listening to events
---

**Location** 

To listen to location, call `watchLocation` method. Method will invoke callback and pass a location object as a parameter. Method will return a watchId . This id can be used to remove a callback.

```
const locationCallback = function (location) {
	const wgsLocation = window.WoosmapGeofencing.Location.jsonToObj(location);
	console.log("Location:" + wgsLocation.Latitude + "," + wgsLocation.Longitude);
};

const error = function (err) {
	console.log(err);
};

var locationWatchId = cordova.plugins.WoosmapGeofencing.watchLocation(locationCallback, error);
```

To stop getting location updates:

```
cordova.plugins.WoosmapGeofencing.clearLocationWatch(locationWatchId, success, error);
```

**Search API** 

To listen to Search API results, call `watchSearchApi` method. Method will invoke a callback with POI object. Method will return a watch id which can be used later to remove the callback.

```
const searchApiCallback = function (poi) {
	console.log("POI:" + poi);
};

const error = function (err) {
	console.log(err);
};

var searchAPIWatchId = cordova.plugins.WoosmapGeofencing.watchSearchAPI(searchApiCallback, error);
```

To stop getting Search API updates:

```
cordova.plugins.WoosmapGeofencing.clearSearchApiWatch(searchAPIWatchId, success, error);
```

**Define the radius value**

When you create a Geofence around a POI (previously imported from Woosmap), manually define the radius value: 
```javascript
const success = function (status) {
    console.log("Status:" + status);
};
const errors = function (err) {
    console.log("Error:" + err);
};
cordova.plugins.WoosmapGeofencing.setPoiRadius(100,success, errors);
```
or choose the user_properties subfield that corresponds to radius value of the Geofence:
```javascript
const success = function (status) {
    console.log("Status:" + status);
};
const errors = function (err) {
    console.log("Error:" + err);
};
cordova.plugins.WoosmapGeofencing.setPoiRadius('radiusPOI',success, errors);
```

**Distance API**

To listen to Distance API results, call `watchDistanceApi` method. Method will invoke a callback with DistanceAPI object. Method will return a watch id which can be used later to remove the callback. 

```
const distanceApiCallback = function (distanceAPI) {
	console.log("Distance API:" + distanceAPI);
};

const error = function (err) {
	console.log(err);
};

var distanceAPIWatchId = cordova.plugins.WoosmapGeofencing.watchDistanceApi(distanceApiCallback, error);
```

To stop listening

```
cordova.plugins.WoosmapGeofencing.clearDistanceApiWatch(distanceAPIWatchId, success, error);
```

**Visits**

To listen to Visits callback, call `watchVisits` method. Method will invoke a callback with Visit object. Method will return a watch id which can be used later to remove the callback.

```
const visitCallback = function (visit) {
	console.log("Visit:" + visit);
};

const error = function (err) {
	console.log(err);
};

var visitWatchId = cordova.plugins.WoosmapGeofencing.watchVisits(visitCallback, error);
```

To stop listening:

```
cordova.plugins.WoosmapGeofencing.clearVisitsWatch(visitWatchId, success, error);
```

**Regions**

Call `watchRegions` method to track Regions. Method will invoke a callback with Region object. Method will return a watch id which can be used later to remove the callback.

```
const regionCallback = function (region) {
	console.log("Region:" + region);
};

const error = function (err) {
	console.log(err);
};

var regionWatchId = cordova.plugins.WoosmapGeofencing.watchRegions(regionCallback, error);
```

To remove watch:

```
cordova.plugins.WoosmapGeofencing.clearRegionsWatch(regionWatchId, success, error);
```

**Airship**

Call `watchAirship` method to listen to custom location generated events from Woosmap Geofencing SDK useful for Airship integration.

```
const airshipCallback = function (airshipData) {
	console.log("Airship Data:" + airshipData);
};

const error = function (err) {
	console.log(err);
};

var airshipWatchId = cordova.plugins.WoosmapGeofencing.watchAirship(airshipCallback, error);
```

To stop listening:

```
cordova.plugins.WoosmapGeofencing.clearAirshipWatch(regionWatchId, success, error);
```


### Adding and removing regions
---

Call `addRegion` method to add a region that you want to monitor. Method will accept an object with the following attributes:

* **regionId** - Id of the region
* **lat** - Latitude
* **lng** - Longitude
* **radius** - Radius in meters

```
const request = {
        "lat": 51.50998000,
        "lng": -0.13370000,
        "regionId": "7F91369E-467C-4CBD-8D41-6509815C4780",
        "radius": 10
    };
cordova.plugins.WoosmapGeofencing.addRegion(request, success, error);
```

Call `removeRegion` method to add a region that you want to monitor. Method will accept the following parameter, and passing a null value will remove all the regions.

* **regionId** - Id of the region
* **lat** - Latitude
* **lng** - Longitude
* **radius** - Radius in meters

```
const request = {
        "lat": 51.50998000,
        "lng": -0.13370000,
        "regionId": "7F91369E-467C-4CBD-8D41-6509815C4780",
        "radius": 10
    };
cordova.plugins.WoosmapGeofencing.removeRegion(request,success, error);
```
### Local database operations
---

* **Get POIs**: Call `getPois` method to get an array of POIs from the local db

```
const success = function (pois) {
        console.log("POIs >>", pois);
        showSuccessToast("Total POIs: " + pois.length);
    };
cordova.plugins.WoosmapDb.getPois(success, error);
```

* **Get Locations**: Call `getLocations` method to get an array of Locations from the local db.

```
const success = function (locations) {
        console.log("Locations >>", locations);
        showSuccessToast("Total Locations: " + locations.length);
    };
cordova.plugins.WoosmapDb.getLocations(success, error);
```

* **Get Visits**: Call `getVisits` method to get an array of Visits from the local db.

```
const success = function (result) {
        showSuccessToast("Total Visits: " + result.length);
    };
cordova.plugins.WoosmapDb.getVisits(success, error);
```

* **Delete Visits** : Call `deleteVisit` method to remove all visits from the local DB.

```
cordova.plugins.WoosmapDb.deleteVisit(success, error);
```

* **Get Regions**: Call `getRegions` method to get an array of Regions from the local db.

```
const success = function (regions) {
        showSuccessToast("Total Regions: " + regions.length);
    };
cordova.plugins.WoosmapDb.getRegions(success, error);
```

* **Get Zones of Interests**: Call `getZois` method to get an array of ZOIs from the local db.

```
const success = function (result) {
        showSuccessToast("Total ZOIs: " + result.length);
    };
cordova.plugins.WoosmapDb.getZois(success, error);
```

* **Delete Zone of Interests**: Call `deleteZoi` method to remove all ZOIs from the local DB. 

```
cordova.plugins.WoosmapDb.deleteZoi(success,error);
```

### Customizing notification in Android
---

On Android platform, when the app goes in the background, Woosmap Geofencing SDK shows an ongoing notification which notifies the user that the location is being used while the app is running. As a developer, you can modify the apearance of this notification. Following properties of the notification can be modified using `customizeNotification` method: 

* Channel id
* Channel name
* Channel description
* Notification title
* Notification text

```
var config = {
        WoosmapNotificationChannelID: "Channel_ID",
        WoosmapNotificationChannelName: "Channel_Name",
        WoosmapNotificationDescriptionChannel: "Channel_Description",
        updateServiceNotificationTitle: "Notification_Title",
        updateServiceNotificationText: "Notification_Text",
        WoosmapNotificationActive: true
    };
cordova.plugins.WoosmapGeofencing.customizeNotification(config,success,error);
```

To customize other attributes of the notification, please check [this](https://community.woosmap.com/geofencing-mobile-sdk/android/setup-firebase-cloud-messaging/#customize-notifications) section of Woosmap Geofencing SDK.

### Initialize Salesforce MarketingCloud Connector
---

The SDK needs some input like credentials and object key to perform the API call to Salesforce Marketing Cloud API.

**Input to initialize the SFMC connector**<br/>

| Parameters                             | Description                                                                                               | Required |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------- | -------- |
| authenticationBaseURI                  | Authentication Base URI                                                                                   | Required |
| restBaseURI                            | REST Base URI                                                                                             | Required |
| client\_id                             | client\_id (journey\_read and list\_and\_subscribers\_read rights are required)                           | Required |
| client\_secret                         | client\_secret (journey\_read and list\_and\_subscribers\_read rights are required)                       | Required |
| contactKey                             | The ID that uniquely identifies a subscriber/contact                                                      | Required |
| regionEnteredEventDefinitionKey        | Set the EventDefinitionKey that you want to use for the Woosmap event `woos_geofence_entered_event`       |          |
| regionExitedEventDefinitionKey         | Set the EventDefinitionKey that you want to use for the Woosmap event `woos_geofence_exited_event`        |          |
| poiEventDefinitionKey                  | Set the EventDefinitionKey that you want to use for the Woosmap event `woos_POI_event`                    |          |
| zoiClassifiedEnteredEventDefinitionKey | Set the EventDefinitionKey that you want to use for the Woosmap event `woos_zoi_classified_entered_event` |          |
| zoiClassifiedExitedEventDefinitionKey  | Set the EventDefinitionKey that you want to use for the Woosmap event `woos_zoi_classified_exited_event`  |          |
| visitEventDefinitionKey                | Set the EventDefinitionKey that you want to use for the Woosmap event `woos_Visit_event`                  |

**Initialize the connector implementation**
``` javascript
    var sfmcCredentials = {
        authenticationBaseURI: "https://xxxxxxxxxx.auth.marketingcloudapis.com",
        restBaseURI: "https://xxxxxxxxxx.rest.marketingcloudapis.com",
        client_id: "xxxxxxxxxxxxxxx",
        client_secret: "xxxxxxxxxxxxxxx",
        contactKey: "ID001",
        regionEnteredEventDefinitionKey: "APIEvent-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
        regionExitedEventDefinitionKey: "APIEvent-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    };
    cordova.plugins.WoosmapGeofencing.setSFMCCredentials(sfmcCredentials, success, errors);
```

--- 

## [JSDoc Reference](https://wgs-cordova-jsdoc.s3.eu-west-3.amazonaws.com/index.html) 

