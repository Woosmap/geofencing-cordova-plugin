/**
 * Contains methods to fetch/remove locations, POIs, regions and visits from the local device DB.
 * @module WoosmapDb
 */
var exec = require("cordova/exec");

/**
 * @method getPois
 * @description A method to retrive the collection of all the POIs from the device DB.
 * @param {function} success A callback that will be called on success with an array of all the POIs as parameter.
 * @param {function} error A callback that will be called on error.
 */
const getPois = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "getPois", []);
};

/**
 * @method getLocations
 * @description A method to retrive the collection of all the locations from the device DB.
 * @param {function} success A callback that will be called on success with an array of locations as parameter.
 * @param {function} error A callback that will be called on error.
 */
const getLocations = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "getLocations", []);
};

/**
 * @method getVisits
 * @description A method to retrive the collection of all the visits from the device DB.
 * @param {function} success A callback that will be called on success with an array of visits as parameter.
 * @param {function} error A callback that will be called on error.
 */
const getVisits = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "getVisits", []);
};
/**
 * @method getRegions
 * @description A method to retrive the collection of all the regions from the device DB.
 * @param {function} success A callback that will be called on success with an array of regions as parameter.
 * @param {function} error A callback that will be called on error.
 */
const getRegions = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "getRegions", []);
};
/**
 * @method getZois
 * @description A method to retrive the collection of all the zones of interests from the device DB.
 * @param {function} success A callback that will be called on success with an array of all the zones of interests as a parameter.
 * @param {function} error  A callback that will be called on error.
 */
const getZois = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "getZois", []);
};
/**
 * @method deleteZoi
 * @description A method to delete all the zones of interests from the device DB.
 * @param {function} success A callback that will be called on success.
 * @param {function} error A callback that will be called on error.
 */
const deleteZoi = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "deleteZoi", []);
};
/**
 * @method deleteLocation
 * @description A method to delete all the locations from the device DB.
 * @param {function} success A callback that will be called on success.
 * @param {function} error A callback that will be called on error.
 */
const deleteLocation = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "deleteLocation", []);
};
/**
 * @method deleteVisit
 * @description A method to delete all the visits from the device DB.
 * @param {function} success  A callback that will be called on success.
 * @param {function} error  A callback that will be called on error.
 */
const deleteVisit = (success, error) => {
  exec(success, error, "WoosmapGeofencing", "deleteVisit", []);
};
const WoosmapDb = {
  getPois,
  getLocations,
  getVisits,
  deleteVisit,
  getRegions,
  getZois,
  deleteZoi,
  deleteLocation,
};

module.exports = WoosmapDb;
