/**
 * @classdesc A class that represents the visits object.
 * @constructs Visit
 * @param {number} accuracy The accuracy in meters.
 * @param {number} arrivalDate The datetime stamp for the arrival at the place of visit.
 * @param {number} date Current datetime stamp.
 * @param {number} latitude The latitude of the place of visit.
 * @param {number} longitude The longitude of the plaee of visit.
 */
class Visit {
  constructor(accuracy, arrivaldate, date, departuredate, latitude, longitude) {
    this.Accuracy = accuracy;
    this.Arrivaldate = arrivaldate;
    this.Date = date;
    this.Departuredate = departuredate;
    this.Latitude = latitude;
    this.Longitude = longitude;
  }
  /**
   * Converts json object to an object of type Visits.
   * @param {Object} json The json representation of the Visits.
   * @returns Object
   * @memberof Visit
   */
  static jsonToObj(json) {
    return new Visit(
      json.accuracy,
      json.arrivaldate,
      json.date,
      json.departuredate,
      json.latitude,
      json.longitude
    );
  }
}
module.exports = Visit;
