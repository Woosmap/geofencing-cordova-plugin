/**
 * @classdesc A class that represents the location object.
 * @constructs Location
 * @param {number} date The datetime stamp.
 * @param {number} latitude The latitude of the location.

 * @param {string} Locationdescription The description of the location. 
 * @param {string} Locationid A unique identifier for the location.
 * @param {number} longitude The longitude of the location.
 */
class Location {
  constructor(date, latitude, locationdescription, locationid, longitude) {
    this.Date = date;
    this.Latitude = latitude;
    this.Locationdescription = locationdescription;
    this.Locationid = locationid;
    this.Longitude = longitude;
  }
  /**
   * Converts json object to an object of type Location.
   * @param {Object} json The json representation of the Location.
   * @returns Object
   * @memberof Location
   */
  static jsonToObj(json) {
    return new Location(
      json.date,
      json.latitude,
      json.locationdescription,
      json.locationid,
      json.longitude
    );
  }
}
module.exports = Location;
