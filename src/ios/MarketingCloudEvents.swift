import Foundation
import CoreLocation
import WoosmapGeofencing

class MarketingData {
    var eventname: String = ""
    var properties: [String: Any]

    required init(eventname: String, properties: [String: Any]) {
        self.eventname = eventname
        self.properties = properties
    }
}

extension Notification.Name {
    static let marketingEvent = Notification.Name("marketingEvent")
}
//TODO: be implemented afterword
public class MarketingCloudEvents {

    public init() {}
    
}
