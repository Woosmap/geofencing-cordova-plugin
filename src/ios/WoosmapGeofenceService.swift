//
//  WoosmapGeofenceService.swift
//  woosmapgeofencingsample
//
//  Created by apple on 02/08/21.
//

import Foundation
import CoreLocation
import WoosmapGeofencing
#if canImport(AirshipCore)
import AirshipCore
#endif

/// Geofence services
@objc(WoosmapGeofenceService) public class WoosmapGeofenceService: NSObject {

    /// Share object for WoosmapGeofenceService
    @objc static var shared: WoosmapGeofenceService?
    private var woosmapKey: String = ""
    private var googleStaticMapKey: String = ""
    private var defaultProfile: String = ""
    private var defaultPOIRadius: String {
        get {
            let defaults = UserDefaults.standard
            let defaultPOIRadius = defaults.string(forKey: "WoosmapGeofenceService.poiradius") ?? ""
            return  defaultPOIRadius
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: "WoosmapGeofenceService.poiradius")
        }
    }

    // Woosmap
    private let woosmapURL = "https://api.woosmap.com"

    // Woosmap SearchAPI Key
    private var searchWoosmapAPI: String { "\(woosmapURL)/stores/search/?private_key=\(woosmapKey)&lat=%@&lng=%@&stores_by_page=1"}

    // Woosmap DistanceAPI
    private var modeDistance = DistanceMode.driving
    private var distanceWoosmapAPI: String { "\(woosmapURL)/distance/distancematrix/json?mode=\(modeDistance)&units=metric&origins=%@,%@&destinations=%@&private_key=\(woosmapKey)&elements=duration_distance"}

    private let dataLocation = DataLocation()
    private let dataPOI = DataPOI()
    private let dataDistance = DataDistance()
    private let dataRegion = DataRegion()
    private let dataVisit = DataVisit()
    private let airshipEvents = AirshipEvents()
    private let marketingCloudEvents = MarketingCloudEvents()

    /// Status of search api On/Off
    @objc public var searchAPIRequestEnable: Bool {
        get {
            return  WoosmapGeofencing.shared.getSearchAPIRequestEnable()
        }
        set {
            WoosmapGeofencing.shared.setSearchAPIRequestEnable(enable: newValue)

        }
    }

    /// Status of distance api On/Off
    @objc public var distanceAPIRequestEnable: Bool {
        get {
            return  WoosmapGeofencing.shared.getDistanceAPIRequestEnable()
        }
        set {
            WoosmapGeofencing.shared.setDistanceAPIRequestEnable(enable: newValue)

        }
    }

    /// status of CreationRegionEnable. On/Off
    @objc public var searchAPICreationRegionEnable: Bool {
        get {
            return  WoosmapGeofencing.shared.getSearchAPICreationRegionEnable()
        }
        set {
            WoosmapGeofencing.shared.setSearchAPICreationRegionEnable(enable: newValue)

        }
    }

    /// Status of HighfrequencyLocation Mode. On/Off
    @objc public var modeHighfrequencyLocation: Bool {
        get {
            return  WoosmapGeofencing.shared.getModeHighfrequencyLocation()
        }
        set {
            WoosmapGeofencing.shared.setModeHighfrequencyLocation(enable: newValue)
        }
    }

    /// Status of tracking state. On/Off
    @objc public var trackingState: Bool {
        get {
            return  WoosmapGeofencing.shared.getTrackingState()
        }
        set {
            WoosmapGeofencing.shared.setTrackingEnable(enable: newValue)
        }
    }

    // MARK: Application events

    /// This callback received when application become active
    @objc func appDidBecomeActive() {
        WoosmapGeofencing.shared.didBecomeActive()
    }

    /// This callback recived when application enter in background mode
    @objc func appDidEnterBackground() {
        if CLLocationManager.authorizationStatus() != .notDetermined {
            WoosmapGeofencing.shared.startMonitoringInBackground()
        }
    }

    /// This callback received when application is terminated
    @objc func appWillTerminate() {
        WoosmapGeofencing.shared.setModeHighfrequencyLocation(enable: false)
    }
    // MARK: Init

    /// Initialize woosGeofencing service with key saved in previous call
    private override init() {
        super.init()
        let defaults = UserDefaults.standard
        let woosmapKey = defaults.string(forKey: "WoosmapGeofenceService.woosmap") ?? ""
        let googleAPIKey = defaults.string(forKey: "WoosmapGeofenceService.googleapi") ?? ""
        let defaultProfile = defaults.string(forKey: "WoosmapGeofenceService.profile") ?? ""
        self.woosmapKey = woosmapKey
        self.defaultProfile = defaultProfile
        googleStaticMapKey = googleAPIKey

        defaults.register(defaults: ["TrackingEnable": true,
                                     "ModeHighfrequencyLocation": false,
                                     "SearchAPIEnable": true,
                                     "DistanceAPIEnable": true,
                                     "searchAPICreationRegionEnable": true])

        self.activateGeofenceService()

    }

    /// Initialize service with keys and profile
    /// - Parameters:
    ///   - woosmapKey: key use for woosmap service
    ///   - googleAPIKey: key use for googlemap service
    ///   - configurationProfile: configuration profile
    private init(_ woosmapKey: String, _ googleAPIKey: String, _ configurationProfile: String) {
        super.init()
        self.woosmapKey = woosmapKey
        self.googleStaticMapKey = googleAPIKey
        self.defaultProfile = configurationProfile

        // Save it on  prefrences
        let defaults = UserDefaults.standard
        defaults.set(woosmapKey, forKey: "WoosmapGeofenceService.woosmap")
        defaults.set(googleAPIKey, forKey: "WoosmapGeofenceService.googleapi")
        defaults.set(configurationProfile, forKey: "WoosmapGeofenceService.profile")

        defaults.register(defaults: ["TrackingEnable": true,
                                     "ModeHighfrequencyLocation": false,
                                     "SearchAPIEnable": true,
                                     "DistanceAPIEnable": true,
                                     "searchAPICreationRegionEnable": true])
        self.activateGeofenceService()
    }

    /// Static instance of woosGeofencing service
    /// - Parameters:
    ///   - woosmapKey: key use for woosmap service
    ///   - googleAPIKey: key use for googlemap service
    ///   - configurationProfile: configuration profile
    @objc public static func setup(woosmapKey: String, googleAPIKey: String, configurationProfile: String) {
        shared = WoosmapGeofenceService.init( woosmapKey, googleAPIKey, configurationProfile)
    }

    /// Creating instance for woosGeofencing service
    @objc public static func setup() {
        shared = WoosmapGeofenceService.init( "", "", "")
    }

    /// Setting up woosmap key
    /// - Parameter key: woosmap key
    /// - Throws: WoosGeofenceError incase of no key pass or empty
    public func setWoosmapAPIKey(key: String) throws {
        if key.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            throw WoosGeofenceError(WoosmapGeofenceMessage.invalidWoosmapKey)
        } else {
            self.woosmapKey = key
            WoosmapGeofencing.shared.setWoosmapAPIKey(key: self.woosmapKey)

            // Set the search url Woosmap API
            WoosmapGeofencing.shared.setSearchWoosmapAPI(api: searchWoosmapAPI)

            // Set the distance url Woosmap API
            WoosmapGeofencing.shared.setDistanceWoosmapAPI(api: distanceWoosmapAPI)

            let defaults = UserDefaults.standard
            defaults.set(key, forKey: "WoosmapGeofenceService.woosmap")
        }
    }

    /// Change tracking mode with new profile
    /// - Parameter profile: profile for tracking.   liveTracking / passiveTracking / visitsTracking
    /// - Throws: in case of wrong profile provided it return error invalidProfile
    public func startTracking(profile: String) throws {
        if let savedProfile = ConfigurationProfile(rawValue: profile) {
            WoosmapGeofencing.shared.startTracking(configurationProfile: savedProfile)
            self.defaultProfile = profile
            let defaults = UserDefaults.standard
            defaults.set(profile, forKey: "WoosmapGeofenceService.profile")

        } else {
            self.defaultProfile = ""
            let defaults = UserDefaults.standard
            defaults.set(self.defaultProfile, forKey: "WoosmapGeofenceService.profile")
            throw WoosGeofenceError(WoosmapGeofenceMessage.invalidProfile)
        }
    }

    /// Stop tracking
    public func stopTracking() {
        WoosmapGeofencing.shared.stopTracking()
    }

    /// activating WoosmapGeofencing with default parameters
    private func activateGeofenceService() {
        // Set private Woosmap key API
        WoosmapGeofencing.shared.setWoosmapAPIKey(key: woosmapKey)
        WoosmapGeofencing.shared.setGMPAPIKey(key: GoogleStaticMapKey)

        // Set the search url Woosmap API
        WoosmapGeofencing.shared.setSearchWoosmapAPI(api: searchWoosmapAPI)

        // Set the distance url Woosmap API
        WoosmapGeofencing.shared.setDistanceWoosmapAPI(api: distanceWoosmapAPI)
        WoosmapGeofencing.shared.setDistanceAPIMode(mode: DistanceMode.driving)

        // Set delegate of protocol Location, POI and Distance
        WoosmapGeofencing.shared.getLocationService().locationServiceDelegate = dataLocation
        WoosmapGeofencing.shared.getLocationService().searchAPIDataDelegate = dataPOI
        WoosmapGeofencing.shared.getLocationService().distanceAPIDataDelegate = dataDistance
        WoosmapGeofencing.shared.getLocationService().regionDelegate = dataRegion

        // Enable Visit and set delegate of protocol Visit
        WoosmapGeofencing.shared.getLocationService().visitDelegate = dataVisit

        // Set delagate for Airship Cloud
        WoosmapGeofencing.shared.getLocationService().airshipEventsDelegate = airshipEvents

        // Set delagate for Marketing Cloud
        WoosmapGeofencing.shared.getLocationService().marketingCloudEventsDelegate = marketingCloudEvents
        if defaultPOIRadius != "" {
            WoosmapGeofencing.shared.setPoiRadius(radius: defaultPOIRadius)
        }

        if let savedProfile = ConfigurationProfile(rawValue: defaultProfile) {
            WoosmapGeofencing.shared.startTracking(configurationProfile: savedProfile)
        }

        // Check if the authorization Status of location Manager
        if CLLocationManager.authorizationStatus() != .notDetermined {
            WoosmapGeofencing.shared.startMonitoringInBackground()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(appWillTerminate), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)

        // MARK: Only  for testing
         // self.searchAPIRequestEnable = true
         // self.distanceAPIRequestEnable = true
         // self.searchAPICreationRegionEnable = true
    }

    /// Adding  new  region
    /// - Parameters:
    ///   - identifier: Region id
    ///   - center: geoLocation point
    ///   - radius: radius of region
    /// - Returns: Status for reagion created or not and new region id from system
    public func addRegion(identifier: String, center: CLLocationCoordinate2D, radius: CLLocationDistance) -> (isCreate: Bool, identifier: String) {
        return WoosmapGeofencing.shared.locationService.addRegion(identifier: identifier, center: center, radius: radius)
    }

    /// Remove region from system
    /// - Parameter center: geoLocation point of region
    public func removeRegion(center: CLLocationCoordinate2D) {
        return WoosmapGeofencing.shared.locationService.removeRegion(center: center)
    }

    /// Remove region from system
    /// - Parameter identifier: region id assined for region
    public func removeRegion(identifier: String) {
        return WoosmapGeofencing.shared.locationService.removeRegion(identifier: identifier)
    }

    /// Get location information for geopoint from woos system
    /// - Parameters:
    ///   - location: geopoint for location
    ///   - locationId: id recorded for that location
    public func searchAPIRequest(location: CLLocationCoordinate2D, locationId: String = "") {
        WoosmapGeofencing.shared.getLocationService().searchAPIRequest(location: CLLocation.init(latitude: location.latitude, longitude: location.longitude), locationId: locationId)
    }

    /// Get distnce between location point and origin
    /// - Parameters:
    ///   - locationOrigin: origin geolocation
    ///   - coordinatesDest: destination  geolocation
    ///   - locationId:  id recorded for that location
    public func distanceAPIRequest(locationOrigin: CLLocationCoordinate2D, coordinatesDest: CLLocation, locationId: String = "") {
        let latDest = coordinatesDest.coordinate.latitude
        let lngDest = coordinatesDest.coordinate.longitude
        let originLocation = CLLocation.init(latitude: locationOrigin.latitude,
                                             longitude: locationOrigin.longitude)
        WoosmapGeofencing.shared.getLocationService().distanceAPIRequest(locationOrigin: originLocation,
                                                                         coordinatesDest: [(latDest, lngDest)],
                                                                         locationId: locationId)
    }

    /// Get distnce between location point and origin
    /// - Parameters:
    ///   - locationOrigin: origin geolocation
    ///   - locationId: id recorded for that location
    public func distanceAPIRequest(locationOrigin: CLLocationCoordinate2D, locationId: String = "") {
        if let poi = DataPOI().getPOIbyLocationID(locationId: locationId) {
            let latDest = poi.latitude
            let lngDest = poi.longitude
            let originLocation = CLLocation.init(latitude: locationOrigin.latitude,
                                                 longitude: locationOrigin.longitude)
            WoosmapGeofencing.shared.getLocationService().distanceAPIRequest(locationOrigin: originLocation,
                                                                             coordinatesDest: [(latDest, lngDest)],
                                                                             locationId: locationId)
        }

    }

    /// List all locations capture by system
    /// - Returns: Array of location captured
    public func  getLocations() -> [Location] {
        let locations = DataLocation().readLocations()
        return locations
    }

    /// List all POIs  capture by system
    /// - Returns: Array of POIs
    public func  getPOIs() -> [POI] {
        let poi = DataPOI().readPOI()
        return poi
    }

    /// List all intrest zone capture by system
    /// - Returns: Array of zones
    public func  getZOIs() -> [ZOI] {
        let zoi = DataZOI().readZOIs()
        return zoi
    }

    /// List all region capture by system
    /// - Returns: Array of regions
    public func  getRegions() -> [Region] {
        let regions = DataRegion().readRegions()
        return regions
    }

    /// List all visits capture by system
    /// - Returns: Array of visits
    public func  getVisits() -> [Visit] {
        let visit = DataVisit().readVisits()
        return visit
    }

    /// Delete all visits from system
    public func  deleteVisits() {
        DataVisit().eraseVisits()
    }

    /// Delete all zois form system
    public func  deleteZoi() {
        DataZOI().eraseZOIs()
    }

    /// Delete all location from system
    public func  deleteLocations() {
        DataLocation().eraseLocations()
        // Native SDK Works independently
        // DataPOI().erasePOI()
    }

    /// Delete all ZOI regions
    public func  deleteAllZoiRegion() {
        WoosmapGeofencing.shared.locationService.removeRegions(type: LocationService.RegionType.custom)
    }

    /// Delete all POI regions
    public func  deleteAllPoiRegion() {
        WoosmapGeofencing.shared.locationService.removeRegions(type: LocationService.RegionType.poi)
    }

    /// Delete all regions
    public func  deleteAllRegion() {
        WoosmapGeofencing.shared.locationService.removeRegions(type: LocationService.RegionType.none)
        DataRegion().eraseRegions()
    }

    @objc static public func mockdata() {
        if WoosmapGeofenceService.shared == nil {
            WoosmapGeofenceService.setup()
        }
        MockDataVisit().mockVisitData()
    }

    /// Setting POI redious
    /// - Parameter radius: integer or string for radius  value
    public func setPoiRadius(radius: String) {
        self.defaultPOIRadius = radius
        if let poiRadius = Int(radius){
            WoosmapGeofencing.shared.setPoiRadius(radius: poiRadius)
        }
        else if let poiRadius = Double(radius){
            WoosmapGeofencing.shared.setPoiRadius(radius: poiRadius)
        }
        else{
            WoosmapGeofencing.shared.setPoiRadius(radius: radius)
        }
        
    }

}

/// WoosGeofense error
struct WoosGeofenceError: Error {

    /// Error info
    let message: String

    /// Initialize
    /// - Parameter message: error detail text
    init(_ message: String) {
        self.message = message
    }

    /// Localized Description
    public var localizedDescription: String {
        return message
    }
}
