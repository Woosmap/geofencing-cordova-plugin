//
//  DataDistance.swift
//  Sample
//
//

import Foundation
import CoreLocation
import WoosmapGeofencing

public class DataDistance: DistanceAPIDelegate {
    public init() {}

    public func distanceAPIResponseData(distanceAPIData: DistanceAPIData, locationId: String) {
        if distanceAPIData.status == "OK" {
            if distanceAPIData.rows?.first?.elements?.first?.status == "OK" {
                let distance = distanceAPIData.rows?.first?.elements?.first?.distance
                let duration = distanceAPIData.rows?.first?.elements?.first?.duration
                if distance != nil && duration != nil {
                    let result: DistanceResponseResult = DistanceResponseResult.init(locationId: locationId, distance: distance!, duration: duration!)
                    NotificationCenter.default.post(name: .distanceCalculated, object: self, userInfo: ["Distance": result])
//                    print(distance?.value ?? 0)
//                    print(duration?.text ?? 0)
                }
            }
        } else {
            let result: DistanceResponseError = DistanceResponseError.init(locationId: locationId, error: distanceAPIData.status ?? "-")
            NotificationCenter.default.post(name: .distanceCalculated, object: self, userInfo: ["Distance": result])
        }
    }

    public func distanceAPIError(error: String) {
        print(error)
    }

}
extension Notification.Name {
    static let distanceCalculated = Notification.Name("POIDistanceCalculated")
}

class DistanceResponseResult {
    var locationId: String = ""
    var distance: Distance
    var duration: Distance
    required init(locationId: String, distance: Distance, duration: Distance) {
        self.locationId = locationId
        self.distance = distance
        self.duration = duration
    }
}
class DistanceResponseError {
    var locationId: String = ""
    var error: String
    required init(locationId: String, error: String ) {
        self.locationId = locationId
        self.error = error
    }
}
