/**
 * @file This is the documentation for the Cordova plugin. Before integrating, read the <a href="https://developers.woosmap.com/products/geofencing-sdk/get-started/">native SDK documentation</a> to familiarize yourself with the platform.
 * See the source on GitHub <a href="https://github.com/sanginfolbs/wgs_geofencing_cordova">here</a>. <br/><br/>
 */

/**
 * Contains methods to monitor location, POIs, Visits and Regions
 * @module WoosmapGeofencing
 */

var exec = require("cordova/exec");
var utils = require("cordova/utils");

/**
 * @method initialize
 * @description Initializes the Woosmap object
 * @param {Object} arg0 - A JSON object with Woosmap Key (optional), Google Maps Api Key (optional) and tracking profile (`liveTracking`,`passiveTracking`,`visitsTracking`).
 * @param {function} success - A callback that will be called on success.
 * @param {function} error - A callback that will be called on error.
 */
const initialize = function (arg0, success, error) {
  if (arg0 == null) {
    arg0 = {};
  }
  exec(success, error, "WoosmapGeofencing", "initialize", [arg0]);
};

/**
 * @method getPermissionsStatus
 * @description A method to check if the app has granted required permissions to track location.
 * @param {function} callback - A callback that will be called with the following status - GRANTED_BACKGROUND, GRANTED_FOREGROUND, DENIED
 */
const getPermissionsStatus = (callback) => {
  exec(
    callback,
    (err) => {
      console.log(err);
    },
    "WoosmapGeofencing",
    "getPermissionsStatus",
    null
  );
};
/**
 * @method requestPermissions
 * @description A method to request the required permissions to collect locations.
 * @param {boolean} background - A boolean value indicating whether the permissions to request is for background or foreground permission.
 * @param {function} success - A callback that will be called on successfull authorization by the app.
 * @param {function} error - A callback that will be called when the app denies permission. The plugin will return an object with a message - 'Permission Denied'.
 */
const requestPermissions = (background, success, error) => {
  exec(success, error, "WoosmapGeofencing", "requestPermissions", [background]);
};
/**
 * @method watchLocation
 * @description Method will
invoke callback and pass a location object as a parameter. Method will return a watchId . This id can be used to remove a callback.
 * @param {function} success - A callback that will be called on success with a location object as a parameter.
 * @param {function} error - A callback that will be called on error.
 * @returns string
 */
const watchLocation = (success, error) => {
  var watchId = utils.createUUID();
  exec(success, error, "WoosmapGeofencing", "watchLocation", [watchId]);
  return watchId;
};
/**
 * @method clearLocationWatch
 * @description A method to stop tracking location for a specified watch. If watchId is null or undefined the plugin will clear all watches.
 * @param {string} watchId An alphanumeric unique identifier.
 */
const clearLocationWatch = (watchId) => {
  exec(null, null, "WoosmapGeofencing", "clearLocationWatch", [watchId]);
};

/**
 * @method watchSearchAPI
 * @description A method to track search API. Method will
invoke a callback with POI object. Method will return a watch id which can be
used later to remove the callback.
 * @param {function} success A callback that will be called on success with a POI object as a parameter.
 * @param {function} error A callback that will be called on error.
 * @returns string
 */
const watchSearchAPI = (success, error) => {
  var watchId = utils.createUUID();
  exec(success, error, "WoosmapGeofencing", "watchSearchAPI", [watchId]);
  return watchId;
};
/**
 * @method clearSearchApiWatch
 * @description A method to clear the specified search API watch. If watchId is passed as null or undefined it will clear all the search api watches.
 * @param {string} watchId An alphanumeric unique identifier.
 */
const clearSearchApiWatch = (watchId) => {
  exec(null, null, "WoosmapGeofencing", "clearSearchApiWatch", [watchId]);
};
/**
 * @method watchDistanceApi
 * @description A method to track the distance API.
 * @param {function} success A callback that will be called on success with a DistanceApi object as parameter.
 * @param {function} error A callback that will be called on error.
 * @returns string
 */
const watchDistanceApi = (success, error) => {
  var watchId = utils.createUUID();
  exec(success, error, "WoosmapGeofencing", "watchDistanceApi", [watchId]);
  return watchId;
};
/**
 * @method clearDistanceApiWatch
 * @description A method to clear the specified watch tracking the distance api. If watchId is null or undefined, it will clear all the watches tracking the distance api.
 * @param {string} watchId An alphanumeric unique identifier
 */
const clearDistanceApiWatch = (watchId) => {
  exec(null, null, "WoosmapGeofencing", "clearDistanceApiWatch", [watchId]);
};
/**
 * @method watchVisits
 * @description A method to track visits. Method will invoke a callback with the visit object. Method will return a watch id which
can be used later to remove the callback.
 * @param {function} success A callback that will be called on success with a visits object as a parameter.
 * @param {function} error A callback that will be called on error.
 * @returns string
 */
const watchVisits = (success, error) => {
  var watchId = utils.createUUID();
  exec(success, error, "WoosmapGeofencing", "watchVisits", [watchId]);
  return watchId;
};

/**
 * @method clearVisitsWatch
 * @description A method to clear the specified watch tracking visits. If the watchId is null or undefined then it will clear all the watches tracking the visits.
 * @param {string} watchId An alphanumeric unique identifier.
 */
const clearVisitsWatch = (watchId) => {
  exec(null, null, "WoosmapGeofencing", "clearVisitsWatch", [watchId]);
};
/**
 * @method watchRegions
 * @description A method to to track
Regions. Method will invoke a callback with Region object. Method will return
a watch id which can be used later to remove the callback.
 * @param {function} success A callback that will be called on success with the region object as parameter.
 * @param {function} error A callback that will be called on error.
 * @returns string
 */
const watchRegions = (success, error) => {
  var watchId = utils.createUUID();
  exec(success, error, "WoosmapGeofencing", "watchRegions", [watchId]);
  return watchId;
};
/**
 * @method clearRegionsWatch
 * @description A method to clear the specified watch tracing the regions. If the watchId is null or undefined then it will clear all the watches tracking the regions.
 * @param {string} watchId An alphanumeric unique identifier.
 */
const clearRegionsWatch = (watchId) => {
  exec(null, null, "WoosmapGeofencing", "clearRegions", [watchId]);
};
/**
 * @method addRegion
 * @description Adds a custom region that you want to monitor.
 * @param {Object} regionInfo A custom JSON object with latitude, longitude and radius.
 * @param {function} success A callback function that will be called on success.
 * @param {function} error A callback function that will be called on error.
 */
const addRegion = (regionInfo, success, error) => {
  exec(success, error, "WoosmapGeofencing", "addRegion", [regionInfo]);
};
/**
 * @method removeRegion
 * @description Removes a region as specified. If the regionInfo is null or undefined then all the regions will be removed.
 * @param {object} regionInfo A JSON object with latitude, longitude and radius..
 * @param {function} success A callback function that will be called on success.
 * @param {function} error A callback function that will be called on error.
 */
const removeRegion = (regionInfo, success, error) => {
  exec(success, error, "WoosmapGeofencing", "removeRegion", [regionInfo]);
};

/**
 * @method startTracking
 * @description A method to start tracking the user's location.
 * @param {string} trackingProfile The configuration profile to use. Values could be anyone of the following: liveTracking, passiveTracking and visitsTracking.
 * @param {function} success A callback function that will be called on success.
 * @param {function} error A callback function that will be called on error.
 */
const startTracking = (trackingProfile, success, error) => {
  exec(success, error, "WoosmapGeofencing", "startTracking", [trackingProfile]);
};
/**
 * @method stopTracking
 * @description Stops tracking the user's location.
 * @param {function} success A callback function that will be called on success.
 * @param {function} error  A callback function that will be called on error
 */
const stopTracking = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "stopTracking", []);
};
/**
 * @method watchAirship
 * @description A method that watches for custom location generated events from Woosmap Geofencing SDK useful for Airship integration for sending contextual notifications to the app.
 * @param {function} success A callback that will be called on success with the name of the event and attributes of POI as parameter.
 * @param {function} error A callback function that will be called on error.
 * @returns string
 */
const watchAirship = (success, error) => {
  var watchId = utils.createUUID();
  exec(success, error, "WoosmapGeofencing", "watchAirship", [watchId]);
  return watchId;
};
/**
 * @method clearAirshipWatch
 * @description A method to clear the specified airship watch.
 * @param {string} watchId An alphanumeric unique identifier.
 */
const clearAirshipWatch = (watchId) => {
  exec(null, null, "WoosmapGeofencing", "clearAirship", [watchId]);
};
/**
 * @method customizeNotification
 * @description A method to customize the title and text of the notification. (Android Only)
 * @param {object} notificationConfig A custom JSON object with title, text, channelId, channelName, channelDescription.
 */
const customizeNotification = (notificationConfig) => {
  exec(null, null, "WoosmapGeofencing", "customizeNotification", [
    notificationConfig,
  ]);
};
/**
 * @method setWoosmapApiKey
 * @description A method that sets Woosmap private API key
 * @param {string} apiKey new API key.
 * @param {function} success A callback that will be called on successfully setting the API key.
 * @param {function} error A callback function that will be called on error.
 */
const setWoosmapApiKey = (apiKey, success, error) => {
  exec(success, error, "WoosmapGeofencing", "setWoosmapApiKey", [apiKey]);
};
/**
 * @method watchMarketingCloud
 * @description A method that watches for custom location generated events from Woosmap Geofencing SDK useful for Marketing Cloud event integration for sending contextual notifications to the app.
 * @param {function} success A callback that will be called on success with the name of the event and attributes of POI as parameter.
 * @param {function} error A callback function that will be called on error.
 * @returns string
 */
const watchMarketingCloud = (success, error) => {
  var watchId = utils.createUUID();
  exec(success, error, "WoosmapGeofencing", "watchMarketingCloud", [watchId]);
  return watchId;
};
/**
 * @method clearMarketingCloudWatch
 * @description A method to clear the specified MarketingCloud watch.
 * @param {string} watchId An alphanumeric unique identifier.
 */
const clearMarketingCloudWatch = (watchId) => {
  exec(null, null, "WoosmapGeofencing", "clearMarketingCloudWatch", [watchId]);
};
/**
 * @method setSFMCCredentials
 * @description Sets Sales Force Marketing Cloud (SFMC) credentials
 * @param {Object} arg0 - A JSON object with SFMC credentials. Keys authenticationBaseURI, restBaseURI, client_id, client_secret and contactKey are required.
 * @param {function} success - A callback that will be called on success.
 * @param {function} error - A callback that will be called on error.
 */
 const setSFMCCredentials = function (arg0, success, error) {
  if (arg0 == null) {
    arg0 = {};
  }
  exec(success, error, "WoosmapGeofencing", "setSFMCCredentials", [arg0]);
};

/**
 * @method setPoiRadius
 * @description When you create a geofence around a POI, manually define the radius value (100.0) or choose the user_properties subfield that corresponds to radius value of the geofence ("radiusPOI").
 * @param {string|int} radius can be integer or string.
 * @param {function} success A callback function that will be called on success.
 * @param {function} error A callback function that will be called on error.
 */
const setPoiRadius = (radius, success, error) => {
  exec(success, error, "WoosmapGeofencing", "setPoiRadius", [radius]);
};
const WoosmapGeofencing = {
  initialize,
  getPermissionsStatus,
  requestPermissions,
  watchLocation,
  clearLocationWatch,
  watchSearchAPI,
  clearSearchApiWatch,
  watchDistanceApi,
  clearDistanceApiWatch,
  watchVisits,
  clearVisitsWatch,
  watchRegions,
  clearRegionsWatch,
  addRegion,
  removeRegion,
  startTracking,
  stopTracking,
  watchAirship,
  clearAirshipWatch,
  customizeNotification,
  setWoosmapApiKey,
  watchMarketingCloud,
  clearMarketingCloudWatch,
  setPoiRadius,
  setSFMCCredentials
};

module.exports = WoosmapGeofencing;
