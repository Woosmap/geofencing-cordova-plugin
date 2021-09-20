/********* WoosmapGeofencing.swift Cordova Plugin Implementation *******/
import CoreLocation
import WoosmapGeofencing

/// CDVWoosmap Geofencing
@objc(CDVWoosmapGeofencing) class CDVWoosmapGeofencing: CDVPlugin {

    /// Location routing to check location permission
    private var  templocationChecker: CLLocationManager!

    /// List of location watch collected by plugin
    private var  locationWatchStack: [String: String] = [:]

    /// List of poi watch collected by plugin
    private var  poiWatchStack: [String: String] = [:]

    /// List all callback collect by Search api call
    private var  searchAPICallStack: [String: String] = [:]

    /// List all distance watch collected by plugin
    private var  distanceWatchStack: [String: String] = [:]

    /// List all callback collect by Distance api call
    private var  distanceAPICallStack: [String: String] = [:]

    /// List all region callback collected by plugin
    private var  regionWatchStack: [String: String] = [:]

    /// List all visit callback collected by plugin
    private var  visitWatchStack: [String: String] = [:]

    /// List all airship callback collected by plugin
    private var  airshipWatchStack: [String: String] = [:]

    /// List all marketing callback collected by plugin. TODO: implementation still pending
    private var  marketingWatchStack: [String: String] = [:]

    /// Initialize cordova plugin
    override func pluginInitialize() {
        super.pluginInitialize()
        templocationChecker = CLLocationManager.init()
        templocationChecker.delegate = self
        templocationChecker.desiredAccuracy = kCLLocationAccuracyBest
        locationWatchStack = [:]
        poiWatchStack = [:]
        searchAPICallStack = [:]
        regionWatchStack = [:]
        visitWatchStack = [:]
        distanceWatchStack = [:]
        distanceAPICallStack = [:]
        airshipWatchStack = [:]
        marketingWatchStack = [:]
    }

    /// Initialize plugin with key
    /// - Parameter command: captureing wooskey, googlekey, profile info for plugin
    @objc(initialize:)
    func initialize(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        var isCallUnsuccessfull = false
        if let initparameters = command.arguments[0] as? [String: String?] {

            var privateKeyWoosmapAPI = ""

            if let keyWoosmapAPI = initparameters["privateKeyWoosmapAPI"] as? String {
                privateKeyWoosmapAPI = keyWoosmapAPI
            }
            var privateKeyGMPStatic = ""
            if let keyGMPStatic = initparameters["privateKeyGMPStatic"] as? String {
                privateKeyGMPStatic = keyGMPStatic
            }

            if let trackingProfile = initparameters["trackingProfile"] as? String {

                if ConfigurationProfile(rawValue: trackingProfile) != nil {
                    WoosmapGeofenceService.setup(woosmapKey: privateKeyWoosmapAPI, googleAPIKey: privateKeyGMPStatic, configurationProfile: trackingProfile)
                } else {
                    isCallUnsuccessfull = true
                    pluginResult = showWoomapError(WoosmapGeofenceMessage.invalidProfile)
                }

            } else {
                WoosmapGeofenceService.setup(woosmapKey: privateKeyWoosmapAPI, googleAPIKey: privateKeyGMPStatic, configurationProfile: "")
            }
            if isCallUnsuccessfull == false {
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: WoosmapGeofenceMessage.initialize
                )
            }

            self.commandDelegate.send(
                pluginResult,
                callbackId: command.callbackId
            )
        }
    }
    
    /// Updating new woosmap key
    /// - Parameter command: -
    @objc(setWoosmapApiKey:)
    func setWoosmapApiKey(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if let woosmapkey = command.arguments[0] as? String {
            if WoosmapGeofenceService.shared != nil{
                do {
                    try WoosmapGeofenceService.shared?.setWoosmapAPIKey(key: woosmapkey)
                    pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: "OK"
                    )
                } catch let error as WoosGeofenceError {
                    pluginResult = showWoomapError(error.localizedDescription)
                } catch {
                    pluginResult = showWoomapError(error.localizedDescription)
                }
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
            }
        }
        else{
            pluginResult = showWoomapError(WoosmapGeofenceMessage.invalidWoosmapKey)
        }
        self.commandDelegate.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }
        
    /// Start Tracking with new profile info
    /// - Parameter command:  liveTracking / passiveTracking / visitsTracking
    @objc(startTracking:)
    func startTracking (command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if let trackingparam = command.arguments[0] as? String {
            do {
                try WoosmapGeofenceService.shared?.startTracking(profile: trackingparam)
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: "OK"
                )
            } catch let error as WoosGeofenceError {
                pluginResult = showWoomapError(error.localizedDescription)
            } catch {
                pluginResult = showWoomapError(error.localizedDescription)
            }

        }

        self.commandDelegate.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }

    /// Stop woosgeolocationservice
    /// - Parameter command: -
    @objc(stopTracking:)
    func stopTracking (command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        WoosmapGeofenceService.shared?.stopTracking()
        pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAs: "OK"
        )

        self.commandDelegate.send(
            pluginResult,
            callbackId: command.callbackId
        )
    }

    /// Get location service permission status
    /// - Parameter command: -
    @objc(getPermissionsStatus:)
    func getPermissionsStatus(command: CDVInvokedUrlCommand) {
        let status = CLLocationManager.authorizationStatus()
        var str: String = "UNKNOWN"
        switch status {
        case .denied:
            str = "DENIED"
        case .restricted:
            str = "DENIED"
        case .authorizedAlways:
            str = "GRANTED_BACKGROUND"
        case .authorizedWhenInUse:
            str = "GRANTED_FOREGROUND"
        default:
            str = "UNKNOWN"
        }
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: str)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    /// Showing location permission popup on screen
    /// - Parameter command: -
    @objc(requestPermissions:)
    func requestPermissions(command: CDVInvokedUrlCommand) {

        // The requestAlwaysAuthorization will show prompt only for the first time. From then onwards, no prompts are shown.
        //https://developer.apple.com/documentation/corelocation/cllocationmanager/1620551-requestalwaysauthorization

        var pluginResult: CDVPluginResult = CDVPluginResult()
        if let backgoundMode = command.arguments[0] as? Bool {

            let status = CLLocationManager.authorizationStatus()

            if backgoundMode {
                if status == .notDetermined {
                    self.templocationChecker.requestAlwaysAuthorization()
                } else if status == .authorizedAlways {
                    pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: WoosmapGeofenceMessage.samePermission
                    )
                } else {
                    let appname: String = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
                    var alertInfo: String = ""
                    if status == .denied {
                        alertInfo = String(format: WoosmapGeofenceMessage.deniedPermission, appname)
                    } else {
                        alertInfo = String(format: WoosmapGeofenceMessage.replacePermission, appname)
                    }
                    let alert = UIAlertController(title: "", message: alertInfo, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: WoosmapGeofenceMessage.cancel, style: UIAlertAction.Style.default, handler: nil))
                    alert.addAction(UIAlertAction(title: WoosmapGeofenceMessage.setting, style: UIAlertAction.Style.default, handler: { _ in
                        if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                        }
                    }))
                    self.viewController.present(alert, animated: true, completion: nil)
                    pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: WoosmapGeofenceMessage.showingPermissionBox
                    )
                }
            } else {
                if status == .notDetermined {
                    self.templocationChecker.requestWhenInUseAuthorization()
                } else if status == .authorizedWhenInUse {
                    pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: WoosmapGeofenceMessage.samePermission
                    )
                } else {
                    let appname: String = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
                    var alertInfo: String = ""
                    if status == .denied {
                        alertInfo = String(format: WoosmapGeofenceMessage.deniedPermission, appname)
                    } else {
                        alertInfo = String(format: WoosmapGeofenceMessage.replacePermission, appname)
                    }
                    let alert = UIAlertController(title: "", message: alertInfo, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: WoosmapGeofenceMessage.cancel, style: UIAlertAction.Style.default, handler: nil))
                    alert.addAction(UIAlertAction(title: WoosmapGeofenceMessage.setting, style: UIAlertAction.Style.default, handler: { _ in
                        if let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
                        }
                    }))
                    self.viewController.present(alert, animated: true, completion: nil)
                    pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: WoosmapGeofenceMessage.showingPermissionBox
                    )
                }

            }

        }
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
    // MARK: Location
    /// Add Location watch
    /// - Parameter command: -
    @objc(watchLocation:)
    func watchLocation(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                locationWatchStack[watchid] = command.callbackId
                if locationWatchStack.count == 1 {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(newLocationAdded(_:)),
                        name: .newLocationSaved,
                        object: nil)
                }
                isWatchSuccesfull = true
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)

            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }
        if !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    /// Remove location watch for given tracking id
    /// - Parameter command: -
    @objc(clearLocationWatch:)
    func clearLocationWatch(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                if let _ = locationWatchStack[watchid] {
                    locationWatchStack.removeValue(forKey: watchid)
                }
                if locationWatchStack.count == 0 {
                    // remove delegate watch
                    NotificationCenter.default.removeObserver(self, name: .newLocationSaved, object: nil)
                }
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: watchid)
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
    // MARK: Visit
    /// Add Visits watch
    /// - Parameter command: -
    @objc(watchVisits:)
    func watchVisits(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                visitWatchStack[watchid] = command.callbackId
                if visitWatchStack.count == 1 {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(newVisitAdded(_:)),
                        name: .newVisitSaved,
                        object: nil)
                }
                isWatchSuccesfull = true
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)

        }
        if !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    /// Clear visit watch
    /// - Parameter command: -
    @objc(clearVisitsWatch:)
    func clearVisitsWatch(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                if let _ = visitWatchStack[watchid] {
                    visitWatchStack.removeValue(forKey: watchid)
                }
                if visitWatchStack.count == 0 {
                    // remove delegate watch
                    NotificationCenter.default.removeObserver(self, name: .newVisitSaved, object: nil)
                }
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: watchid)
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    // MARK: Region
    /// Add region watch
    /// - Parameter command: -
    @objc(watchRegions:)
    func watchRegions(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                regionWatchStack[watchid] = command.callbackId
                if regionWatchStack.count == 1 {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(didEventPOIRegion(_:)),
                        name: .didEventPOIRegion,
                        object: nil)
                }
                isWatchSuccesfull = true
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }
        if !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    /// Remove retion watch for given tracking id
    /// - Parameter command: -
    @objc(clearRegions:)
    func clearRegions(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                if let _ = regionWatchStack[watchid] {
                    regionWatchStack.removeValue(forKey: watchid)
                }
                if regionWatchStack.count == 0 {
                    // remove delegate watch
                    NotificationCenter.default.removeObserver(self, name: .didEventPOIRegion, object: nil)
                }
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: watchid)
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    /// Added new region on it
    /// - Parameter command: -
    @objc(addRegion:)
    func addRegion(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let regioninfo = command.arguments[0] as? [String: Any] {
                var regionid = UUID().uuidString
                var radius = 100
                var lat: Double = 0
                var lng: Double = 0
                if let inputregionId = regioninfo["regionId"] as? String {
                    regionid = inputregionId
                }
                if let inputCoordinate = regioninfo["lat"]  as? String {
                    lat = Double(inputCoordinate) ?? 0
                } else if let inputCoordinate = regioninfo["lat"]  as? Double {
                    lat = inputCoordinate
                }
                if let inputCoordinate = regioninfo["lng"]  as? String {
                    lng = Double(inputCoordinate) ?? 0
                } else if let inputCoordinate = regioninfo["lng"]  as? Double {
                    lng = inputCoordinate
                }
                if let inputradius = regioninfo["radius"]  as? String {
                    radius = Int(inputradius) ?? 0
                } else if let inputradius = regioninfo["radius"]  as? Int {
                    radius = inputradius
                }

                if lat == 0 || lng == 0 {
                    pluginResult = showWoomapError(WoosmapGeofenceMessage.invalidLocation)
                } else {
                    let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)

                    let (regionIsCreated, identifier) = WoosmapGeofenceService.shared!.addRegion(identifier: regionid, center: coordinate, radius: CLLocationDistance(radius))
                    var result: [AnyHashable: Any] = [:]
                    result["regionid"] = identifier
                    result["iscreated"] = regionIsCreated
                    pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: result)
                }
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.regionInfoEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
    @objc(removeRegion:)
    func removeRegion(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let regioninfo = command.arguments[0] as? [String: Any] {
                if let regionid = regioninfo["regionId"] as? String {
                    WoosmapGeofenceService.shared!.removeRegion(identifier: regionid)
                    pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: WoosmapGeofenceMessage.regionDeleted)
                } else {
                    var lat: Double = 0
                    var lng: Double = 0
                    if let inputCoordinate = regioninfo["lat"]  as? Double {
                        lat = inputCoordinate
                    }
                    if let inputCoordinate = regioninfo["lng"]  as? Double {
                        lng = inputCoordinate
                    }
                    if lat == 0 || lng == 0 {
                        pluginResult = showWoomapError(WoosmapGeofenceMessage.invalidLocation)
                    } else {
                        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)

                        WoosmapGeofenceService.shared!.removeRegion( center: coordinate)
                        pluginResult = CDVPluginResult(
                            status: CDVCommandStatus_OK,
                            messageAs: WoosmapGeofenceMessage.regionDeleted)
                    }
                }
            } else {
                let myarg: String? = command.arguments[0] as? String
                if myarg == nil {
                    WoosmapGeofenceService.shared!.deleteAllRegion()
                    pluginResult = CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: WoosmapGeofenceMessage.regionDeleted)
                } else {
                    pluginResult = showWoomapError(WoosmapGeofenceMessage.regionInfoEmptyOrNull)
                }
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    // MARK: POI
    @objc(watchSearchAPI:)
    func watchSearchAPI(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                poiWatchStack[watchid] = command.callbackId
                if poiWatchStack.count == 1 && searchAPICallStack.count == 0 {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(newPOIAdded(_:)),
                        name: .newPOISaved,
                        object: nil)
                }
                isWatchSuccesfull = true
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)

        }
        if !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(clearSearchApiWatch:)
    func clearSearchApiWatch(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                if let _ = poiWatchStack[watchid] {
                    poiWatchStack.removeValue(forKey: watchid)
                }
                if poiWatchStack.count == 0 && searchAPICallStack.count == 0 {
                    // remove delegate watch
                    NotificationCenter.default.removeObserver(self, name: .newPOISaved, object: nil)
                }
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: watchid)
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(searchAPIRequest:)
    func searchAPIRequest(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {

            if let request = command.arguments[0] as? [String: Any] {
                var lat: Double = 0
                var lng: Double = 0
                var locationId: String = UUID().uuidString
                if let inputCoordinate = request["lat"]  as? Double {
                    lat = inputCoordinate
                }
                if let inputCoordinate = request["lng"]  as? Double {
                    lng = inputCoordinate
                }
                if let inputlocationId = request["locationId"]  as? String {
                    locationId = inputlocationId
                }
                if lat == 0 || lng == 0 {
                    pluginResult = showWoomapError(WoosmapGeofenceMessage.searchpoiRequestInfoEmptyOrNull)
                } else {
                    searchAPICallStack[locationId] = command.callbackId
                    if poiWatchStack.count == 0 && searchAPICallStack.count == 1 {
                        NotificationCenter.default.addObserver(
                            self,
                            selector: #selector(newPOIAdded(_:)),
                            name: .newPOISaved,
                            object: nil)
                    }

                    WoosmapGeofenceService.shared?.searchAPIRequest(location: CLLocationCoordinate2D.init(latitude: lat, longitude: lng), locationId: locationId)
                    isWatchSuccesfull = true

                }
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.searchpoiRequestInfoEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }
        if !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    // MARK: Distance
    @objc(watchDistanceApi:)
    func watchDistanceApi(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                distanceWatchStack[watchid] = command.callbackId
                if distanceWatchStack.count == 1 && distanceAPICallStack.count == 0 {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(distanceCalculated(_:)),
                        name: .distanceCalculated,
                        object: nil)
                }
                isWatchSuccesfull = true
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)

        }
        if !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(clearDistanceApiWatch:)
    func clearDistanceApiWatch(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                if let _ = distanceWatchStack[watchid] {
                    distanceWatchStack.removeValue(forKey: watchid)
                }
                if distanceAPICallStack.count == 0 && distanceWatchStack.count == 0 {
                    // remove delegate watch
                    NotificationCenter.default.removeObserver(self, name: .distanceCalculated, object: nil)
                }
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: watchid)
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(distanceAPIRequest:)
    func distanceAPIRequest(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false

        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {

            if let request = command.arguments[0] as? [String: Any] {
                var lat: Double = 0
                var lng: Double = 0
                var locationId: String = UUID().uuidString
                if let inputCoordinate = request["lat"]  as? Double {
                    lat = inputCoordinate
                }
                if let inputCoordinate = request["lng"]  as? Double {
                    lng = inputCoordinate
                }
                if let inputlocationId = request["locationId"]  as? String {
                    locationId = inputlocationId
                }
                if lat == 0 || lng == 0 {
                    pluginResult = showWoomapError(WoosmapGeofenceMessage.searchpoiRequestInfoEmptyOrNull)
                } else {
                    distanceAPICallStack[locationId] = command.callbackId
                    if  distanceAPICallStack.count == 1 && distanceWatchStack.count == 0 {
                        NotificationCenter.default.addObserver(
                            self,
                            selector: #selector(distanceCalculated(_:)),
                            name: .distanceCalculated,
                            object: nil)
                    }
                    WoosmapGeofenceService.shared?.distanceAPIRequest(locationOrigin: CLLocationCoordinate2D.init(latitude: lat, longitude: lng), locationId: locationId)
                    isWatchSuccesfull = true
                }
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.searchpoiRequestInfoEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }
        if  !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }

    }
    // MARK: Airship
    @objc(watchAirship:)
    func watchAirship(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                airshipWatchStack[watchid] = command.callbackId
                if airshipWatchStack.count == 1 {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(airshipEvents(_:)),
                        name: .airshipEvent,
                        object: nil)
                }
                isWatchSuccesfull = true
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)

        }
        if !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(clearAirship:)
    func clearAirship(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                if let _ = airshipWatchStack[watchid] {
                    airshipWatchStack.removeValue(forKey: watchid)
                }
                if airshipWatchStack.count == 0 {
                    // remove delegate watch
                    NotificationCenter.default.removeObserver(self, name: .airshipEvent, object: nil)
                }
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: watchid)
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
    
    // MARK: Marketing
    @objc(watchMarketingCloud:)
    func watchMarketingCloud(command: CDVInvokedUrlCommand) {
        var isWatchSuccesfull: Bool = false
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                marketingWatchStack[watchid] = command.callbackId
                if marketingWatchStack.count == 1 {
                    NotificationCenter.default.addObserver(
                        self,
                        selector: #selector(marketingEvents(_:)),
                        name: .marketingEvent,
                        object: nil)
                }
                isWatchSuccesfull = true
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)

        }
        if !isWatchSuccesfull {
            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(clearMarketingCloudWatch:)
    func clearMarketingCloudWatch(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            if let watchid = command.arguments[0] as? String {
                if let _ = marketingWatchStack[watchid] {
                    marketingWatchStack.removeValue(forKey: watchid)
                }
                if marketingWatchStack.count == 0 {
                    // remove delegate watch
                    NotificationCenter.default.removeObserver(self, name: .marketingEvent, object: nil)
                }
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: watchid)
            } else {
                pluginResult = showWoomapError(WoosmapGeofenceMessage.watchIDEmptyOrNull)
            }
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    // MARK: DB
    @objc(getLocations:)
    func getLocations(command: CDVInvokedUrlCommand) {
        self.commandDelegate.run {
            var pluginResult: CDVPluginResult = CDVPluginResult()
            if WoosmapGeofenceService.shared != nil {
                let capturedLocation = WoosmapGeofenceService.shared!.getLocations()
                var result: [[AnyHashable: Any]] = []

                for item in capturedLocation {
                    result.append(self.formatLocationData(woosdata: item))
                }
                pluginResult = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: result)
            } else {
                pluginResult = self.showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
            }

            self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }

    @objc(getPois:)
    func getPois(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            let capturedPois = WoosmapGeofenceService.shared!.getPOIs()
            var result: [[AnyHashable: Any]] = []

            for item in capturedPois {
                result.append(formatPOIData(woosdata: item))
            }
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: result)
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(getVisits:)
    func getVisits(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            let capturedVisits = WoosmapGeofenceService.shared!.getVisits()
            var result: [[AnyHashable: Any]] = []

            for item in capturedVisits {
                result.append(formatVisitData(woosdata: item))
            }
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: result)
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(deleteVisit:)
    func deleteVisit(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            WoosmapGeofenceService.shared!.deleteVisits()

            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: WoosmapGeofenceMessage.visitDeleted)
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(getRegions:)
    func getRegions(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            let capturedRegions = WoosmapGeofenceService.shared!.getRegions()
            var result: [[AnyHashable: Any]] = []

            for item in capturedRegions {
                result.append(formatRegionData(woosdata: item))
            }
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: result)
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(getZois:)
    func getZois(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            let capturedzois = WoosmapGeofenceService.shared!.getZOIs()
            var result: [[AnyHashable: Any]] = []

            for item in capturedzois {
                result.append(formatZOIData(woosdata: item))
            }
            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: result)
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }
    @objc(deleteZoi:)
    func deleteZoi(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            WoosmapGeofenceService.shared!.deleteZoi()

            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: WoosmapGeofenceMessage.zoiDeleted)
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    @objc(deleteLocation:)
    func deleteLocation(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        if WoosmapGeofenceService.shared != nil {
            WoosmapGeofenceService.shared!.deleteLocations()

            pluginResult = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: WoosmapGeofenceMessage.locationDeleted)
        } else {
            pluginResult = showWoomapError(WoosmapGeofenceMessage.woosemapNotInitialized)
        }

        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)
    }

    // MARK: Supporting functions
    private func formatLocationData(woosdata: Location) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        if let date = woosdata.date {
            result["date"] = date.timeIntervalSince1970 * 1000
        } else {
            result["date"] = 0
        }
        result["latitude"] = woosdata.latitude
        result["locationdescription"] = woosdata.locationDescription
        result["locationid"] = woosdata.locationId
        result["longitude"] = woosdata.longitude
        return result
    }
    private func formatPOIData(woosdata: POI) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        if let data = woosdata.jsonData {
            do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                result["jsondata"] = json
            } catch { print("Invalid JSON format") }
        }
        result["city"] = woosdata.city
        result["idstore"] = woosdata.idstore
        result["name"] = woosdata.name
        if let date = woosdata.date {
            result["date"] = date.timeIntervalSince1970 * 1000
        } else {
            result["date"] = 0
        }
        result["distance"] = woosdata.distance
        result["duration"] = woosdata.duration ?? "-"
        result["latitude"] = woosdata.latitude
        result["locationid"] = woosdata.locationId
        result["longitude"] = woosdata.longitude
        result["zipcode"] = woosdata.zipCode
        result["radius"] = woosdata.radius
        result["address"] = woosdata.address
        result["countrycode"] = woosdata.countryCode
        result["tags"] = woosdata.tags
        result["types"] = woosdata.types
        result["contact"] = woosdata.contact
        return result
    }
    private func formatZOIData(woosdata: ZOI) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        result["accumulator"] = woosdata.accumulator
        result["age"] = woosdata.age
        result["covariance_det"] = woosdata.covariance_det
        result["duration"] = woosdata.duration
        if let date = woosdata.endTime {
            result["endtime"] = date.timeIntervalSince1970 * 1000
        } else {
            result["endtime"] = 0
        }
        result["idvisits"] = woosdata.idVisits
        result["latmean"] = woosdata.latMean
        result["lngmean"] = woosdata.lngMean
        result["period"] = woosdata.period
        result["prior_probability"] = woosdata.prior_probability
        result["starttime"] = woosdata.startTime
        result["weekly_density"] = woosdata.weekly_density
        result["wktpolygon"] = woosdata.wktPolygon
        result["x00covariance_matrix_inverse"] = woosdata.x00Covariance_matrix_inverse
        result["x01covariance_matrix_inverse"] = woosdata.x01Covariance_matrix_inverse
        result["x10covariance_matrix_inverse"] = woosdata.x10Covariance_matrix_inverse
        result["x11covariance_matrix_inverse"] = woosdata.x11Covariance_matrix_inverse
        return result
    }
    private func formatVisitData(woosdata: Visit) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        result["accuracy"] = woosdata.accuracy
        if let date = woosdata.date {
            result["date"] = date.timeIntervalSince1970 * 1000
        } else {
            result["date"] = 0
        }
        if let date = woosdata.arrivalDate {
            result["arrivaldate"] = date.timeIntervalSince1970 * 1000
        } else {
            result["arrivaldate"] = 0
        }
        if let date = woosdata.departureDate {
            result["departuredate"] = date.timeIntervalSince1970 * 1000
        } else {
            result["departuredate"] = 0
        }
        result["latitude"] = woosdata.latitude
        result["longitude"] = woosdata.longitude
        return result
    }
    private func formatRegionData(woosdata: Region) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        if let date = woosdata.date {
            result["date"] = date.timeIntervalSince1970 * 1000
        } else {
            result["date"] = 0
        }
        result["didenter"] = woosdata.didEnter
        result["identifier"] = woosdata.identifier
        result["latitude"] = woosdata.latitude
        result["longitude"] = woosdata.longitude
        result["radius"] = woosdata.radius
        result["frompositiondetection"] = woosdata.fromPositionDetection
        return result
    }

    private func formatDistanceData(woosdata: DistanceResponseResult) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        result["locationid"] = woosdata.locationId
        result["distance"] = woosdata.distance.text
        result["duration"] = woosdata.duration.text
        return result
    }
    
    private func formatAirshipData(woosdata: AirshipData) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        result["name"] = woosdata.eventname
        var propertiesFormat: [AnyHashable: Any] = [:]
        woosdata.properties.keys.forEach { airshipkey in
            if let value = woosdata.properties[airshipkey] as? Date {
                propertiesFormat[airshipkey] = value.timeIntervalSince1970 * 1000
            } else if let value = woosdata.properties[airshipkey] as? Double {
                propertiesFormat[airshipkey] = value
            } else if let value = woosdata.properties[airshipkey] as? Int {
                propertiesFormat[airshipkey] = value
            } else if let value = woosdata.properties[airshipkey] as? Int32 {
                propertiesFormat[airshipkey] = value
            } else if let value = woosdata.properties[airshipkey] as? Bool {
                propertiesFormat[airshipkey] = value
            } else if let value = woosdata.properties[airshipkey] as? String {
                propertiesFormat[airshipkey] = value
            } else {
                propertiesFormat[airshipkey] = woosdata.properties[airshipkey]
            }
        }
        result["properties"] = propertiesFormat
        return result
    }
    
    private func formatMarketingData(woosdata: MarketingData) -> [AnyHashable: Any] {
        var result: [AnyHashable: Any] = [:]
        result["name"] = woosdata.eventname
        var propertiesFormat: [AnyHashable: Any] = [:]
        woosdata.properties.keys.forEach { marketingkey in
            if let value = woosdata.properties[marketingkey] as? Date {
                propertiesFormat[marketingkey] = value.timeIntervalSince1970 * 1000
            } else if let value = woosdata.properties[marketingkey] as? Double {
                propertiesFormat[marketingkey] = value
            } else if let value = woosdata.properties[marketingkey] as? Int {
                propertiesFormat[marketingkey] = value
            } else if let value = woosdata.properties[marketingkey] as? Int32 {
                propertiesFormat[marketingkey] = value
            } else if let value = woosdata.properties[marketingkey] as? Bool {
                propertiesFormat[marketingkey] = value
            } else if let value = woosdata.properties[marketingkey] as? String {
                propertiesFormat[marketingkey] = value
            } else {
                propertiesFormat[marketingkey] = woosdata.properties[marketingkey]
            }
        }
        result["properties"] = propertiesFormat
        return result
    }

    private func showWoomapError(_ msg: String) -> CDVPluginResult {
        var pluginResult = CDVPluginResult()
        var result: [AnyHashable: Any] = [:]
        result["message"] = msg
        pluginResult = CDVPluginResult(
            status: CDVCommandStatus_ERROR,
            messageAs: result)
        return pluginResult!
    }

    // MARK: Events
    @objc func newLocationAdded(_ notification: Notification) {
        if let location = notification.userInfo?["Location"] as? Location {
            let pluginResult: CDVPluginResult  = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: formatLocationData(woosdata: location)
            )

            for watchid in locationWatchStack.keys {
                let callbackID = locationWatchStack[watchid]
                pluginResult.setKeepCallbackAs(true)
                self.commandDelegate.send(pluginResult, callbackId: callbackID)
            }
        }
    }
    @objc func newPOIAdded(_ notification: Notification) {
        if let poi = notification.userInfo?["POI"] as? POI {
            if let locationid: String = poi.locationId {
                let pluginResult: CDVPluginResult  = CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: formatPOIData(woosdata: poi)
                )

                if let singleWatch = searchAPICallStack[locationid] {
                    searchAPICallStack.removeValue(forKey: locationid)
                    self.commandDelegate.send(pluginResult, callbackId: singleWatch)
                    if searchAPICallStack.count == 0 && poiWatchStack.count == 0 {
                        // remove delegate watch
                        NotificationCenter.default.removeObserver(self, name: .newPOISaved, object: nil)
                    }
                } else {
                    for watchid in poiWatchStack.keys {
                        let callbackID = poiWatchStack[watchid]
                        pluginResult.setKeepCallbackAs(true)
                        self.commandDelegate.send(pluginResult, callbackId: callbackID)
                    }
                }
            }
        }
    }
    @objc func newVisitAdded(_ notification: Notification) {
        if let visit = notification.userInfo?["Visit"] as? Visit {
            let pluginResult: CDVPluginResult  = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: formatVisitData(woosdata: visit)
            )

            for watchid in visitWatchStack.keys {
                let callbackID = visitWatchStack[watchid]
                pluginResult.setKeepCallbackAs(true)
                self.commandDelegate.send(pluginResult, callbackId: callbackID)
            }
        }
    }
    @objc func didEventPOIRegion(_ notification: Notification) {
        if let region = notification.userInfo?["Region"] as? Region {
            let pluginResult: CDVPluginResult  = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: formatRegionData(woosdata: region)
            )

            for watchid in regionWatchStack.keys {
                let callbackID = regionWatchStack[watchid]
                pluginResult.setKeepCallbackAs(true)
                self.commandDelegate.send(pluginResult, callbackId: callbackID)
            }
        }
    }
    @objc func distanceCalculated(_ notification: Notification) {
        var pluginResult: CDVPluginResult = CDVPluginResult()
        var locationid: String = ""

        if let distance = notification.userInfo?["Distance"] as? DistanceResponseResult {
            locationid = distance.locationId
            pluginResult  = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: formatDistanceData(woosdata: distance)
            )
        } else if let distanceerror = notification.userInfo?["Distance"] as? DistanceResponseError {
            locationid = distanceerror.locationId
            pluginResult  = CDVPluginResult(
                status: CDVCommandStatus_ERROR,
                messageAs: distanceerror.error
            )
        }

        if let singleWatch = distanceAPICallStack[locationid] {
            distanceAPICallStack.removeValue(forKey: locationid)
            self.commandDelegate.send(pluginResult, callbackId: singleWatch)
            if distanceAPICallStack.count == 0 && distanceWatchStack.count == 0 {
                // remove delegate watch
                NotificationCenter.default.removeObserver(self, name: .distanceCalculated, object: nil)
            }
        } else {
            for watchid in distanceWatchStack.keys {
                let callbackID = distanceWatchStack[watchid]
                pluginResult.setKeepCallbackAs(true)
                self.commandDelegate.send(pluginResult, callbackId: callbackID)
            }
        }
    }

    @objc func airshipEvents(_ notification: Notification) {
        if let airshipdata = notification.userInfo?["Airship"] as? AirshipData {
            let pluginResult: CDVPluginResult  = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: formatAirshipData(woosdata: airshipdata)
            )

            for watchid in airshipWatchStack.keys {
                let callbackID = airshipWatchStack[watchid]
                pluginResult.setKeepCallbackAs(true)
                self.commandDelegate.send(pluginResult, callbackId: callbackID)
            }
        }
    }
    
    @objc func marketingEvents(_ notification: Notification) {
        if let marketingdata = notification.userInfo?["Marketing"] as? MarketingData {
            let pluginResult: CDVPluginResult  = CDVPluginResult(
                status: CDVCommandStatus_OK,
                messageAs: formatMarketingData(woosdata: marketingdata)
            )

            for watchid in marketingWatchStack.keys {
                let callbackID = marketingWatchStack[watchid]
                pluginResult.setKeepCallbackAs(true)
                self.commandDelegate.send(pluginResult, callbackId: callbackID)
            }
        }
    }

}

extension CDVWoosmapGeofencing: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failed")
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        print("done")
        templocationChecker.stopUpdatingLocation()
    }
}