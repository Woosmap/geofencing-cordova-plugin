/**
 * @classdesc A class that represents the Marketing Cloud object.
 * @constructs MarketingCloud
 * @param {string} name The name of the custom event.
 * @param {string} properties The attributes of the POI such as `name`, `address`, `zipCode` etc.
 */
class MarketingCloud {
    constructor(name, properties) {
        this.Name = name;
        this.Properties = properties;
    }
    /**
     * Converts json object to an object of type MarketingCloud.
     * @param {Object} json The json representation of MarketingCloud.
     * @returns Object
     * @memberof MarketingCloud
     */
    static jsonToObj(json) {
        return new Airship(json.name, json.properties);
    }
}
module.exports = MarketingCloud;
