import Foundation
import CoreLocation
import WoosmapGeofencing

@objc(MarketingData) class MarketingData: NSObject {
    @objc var eventname: String = ""
    @objc var properties: [String: Any]

    required init(eventname: String, properties: [String: Any]) {
        self.eventname = eventname
        self.properties = properties
    }
}

extension Notification.Name {
    static let marketingEvent = Notification.Name("marketingEvent")
}

public class MarketingCloudEvents: MarketingCloudEventsDelegate {
    
    public init() {}
    
    public func regionEnterEvent(regionEvent: Dictionary<String, Any>, eventName: String) {
        // here you can modify your event name and add your data in the dictonnary
        print("MarketingCloudEvents regionEnterEvent")
        let result: MarketingData = MarketingData.init(eventname: eventName, properties: regionEvent)
        NotificationCenter.default.post(name: .marketingEvent, object: self, userInfo: ["Marketing": result])
    }
    
    public func regionExitEvent(regionEvent: Dictionary<String, Any>, eventName: String) {
        // here you can modify your event name and add your data in the dictonnary
        print("MarketingCloudEvents regionExitEvent")
        let result: MarketingData = MarketingData.init(eventname: eventName, properties: regionEvent)
        NotificationCenter.default.post(name: .marketingEvent, object: self, userInfo: ["Marketing": result])
    }
    
    public func visitEvent(visitEvent: Dictionary<String, Any>, eventName: String) {
        // here you can modify your event name and add your data in the dictonnary
        print("MarketingCloudEvents visitEvent")
        let result: MarketingData = MarketingData.init(eventname: eventName, properties: visitEvent)
        NotificationCenter.default.post(name: .marketingEvent, object: self, userInfo: ["Marketing": result])
    }
    
    public func poiEvent(POIEvent: Dictionary<String, Any>, eventName: String) {
        // here you can modify your event name and add your data in the dictonnary
        print("MarketingCloudEvents poiEvent")
        let result: MarketingData = MarketingData.init(eventname: eventName, properties: POIEvent)
        NotificationCenter.default.post(name: .marketingEvent, object: self, userInfo: ["Marketing": result])
    }
    
    public func ZOIclassifiedEnter(regionEvent: Dictionary<String, Any>, eventName: String) {
        // here you can modify your event name and add your data in the dictonnary
        print("MarketingCloudEvents ZOIclassifiedEnter")
        let result: MarketingData = MarketingData.init(eventname: eventName, properties: regionEvent)
        NotificationCenter.default.post(name: .marketingEvent, object: self, userInfo: ["Marketing": result])
    }
    
    public func ZOIclassifiedExit(regionEvent: Dictionary<String, Any>, eventName: String) {
        // here you can modify your event name and add your data in the dictonnary
        print("MarketingCloudEvents ZOIclassifiedExit")
        let result: MarketingData = MarketingData.init(eventname: eventName, properties: regionEvent)
        NotificationCenter.default.post(name: .marketingEvent, object: self, userInfo: ["Marketing": result])
    }
}
