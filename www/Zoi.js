/**
 * @classdesc A class that represents the Zones of Interest (ZOI) object.
 * @constructs Zoi
 * @param {number} accumulator Represents the number of visits used to build the ZOI (only for calculation of ZOI)
 * @param {number} age Age is used to determine if a ZOI should be deleted by the algorithm (only for calculation of ZOI)
 * @param {number} covariance_det The covariance determinant (only for calculation of ZOI)
 * @param {number} duration The duration of all the accumulated visits of the ZOI
 * @param {number} endtime The exit date of the last ZOI visit
 * @param {string[]} idvisits The list of id visits included in this ZOI
 * @param {number} latmean The latitude of the center of the ZOI
 * @param {number} lngmean The longitude of the center of the ZOI
 * @param {string} period The classification of the period (HOME, WORK, OTHER or NO QUALIFIER)
 * @param {number} prior_probability Estimation of probability (only for calculation of ZOI)
 * @param {number} starttime The entry date for the first ZOI visit
 * @param {number} weekly_density The weekly density of the ZOI visit (only for classification of ZOI)
 * @param {string} wktpolygon This is the Well-known text representation of geometry of the ZOI polygon.
 * @param {number} x00covariance_matrix_inverse The covariance of a cluster (only for calculation of ZOI)
 * @param {number} x01covariance_matrix_inverse The covariance of a cluster (only for calculation of ZOI)
 * @param {number} x10covariance_matrix_inverse The covariance of a cluster (only for calculation of ZOI)
 * @param {number} x11covariance_matrix_inverse The covariance of a cluster (only for calculation of ZOI)

 */
class Zoi {
  constructor(
    accumulator,
    age,
    covariance_det,
    duration,
    endtime,
    idvisits,
    latmean,
    lngmean,
    period,
    prior_probability,
    starttime,
    weekly_density,
    wktpolygon,
    x00covariance_matrix_inverse,
    x01covariance_matrix_inverse,
    x10covariance_matrix_inverse,
    x11covariance_matrix_inverse
  ) {
    this.Accumulator = accumulator;
    this.Age = age;
    this.Covariance_Det = covariance_det;
    this.Duration = duration;
    this.Endtime = endtime;
    this.Idvisits = idvisits;
    this.Latmean = latmean;
    this.Lngmean = lngmean;
    this.Period = period;
    this.Prior_Probability = prior_probability;
    this.Starttime = starttime;
    this.Weekly_Density = weekly_density;
    this.Covariance_Det = covariance_det;
    this.X00Covariance_Matrix_Inverse = x00covariance_matrix_inverse;
    this.X01Covariance_Matrix_Inverse = x01covariance_matrix_inverse;
    this.X10Covariance_Matrix_Inverse = x10covariance_matrix_inverse;
    this.X11Covariance_Matrix_Inverse = x11covariance_matrix_inverse;
  }
  /**
   * Converts json object to an object of type Zoi.
   * @param {Object} json The json representation of the Zoi.
   * @returns Object
   * @memberof Zoi
   */
  static jsonToObj(json) {
    return new Zoi(
      json.accumulator,
      json.age,
      json.covariance_det,
      json.duration,
      json.endtime,
      json.idvisits,
      json.latmean,
      json.lngmean,
      json.period,
      json.prior_probability,
      json.starttime,
      json.weekly_density,
      json.wktpolygon,
      json.x00covariance_matrix_inverse,
      json.x01covariance_matrix_inverse,
      json.x10covariance_matrix_inverse,
      json.x11covariance_matrix_inverse
    );
  }
}
module.exports = Zoi;
