//
//  WoosmapGeofenceMessage.swift
//  testproject
//
//  Created by apple on 10/08/21.
//

import UIKit

internal struct WoosmapGeofenceMessage {
    static let woosemapNotInitialized = "Woosmap not initialized"
    static let watchIDEmptyOrNull = "Watch id cannot be empty or null"
    static let regionInfoEmptyOrNull = "regionInfo cannot be empty or null"
    static let invalidLocation = "Invalid location"
    static let searchpoiRequestInfoEmptyOrNull = "search poi Request cannot be empty or null"
    static let showingPermissionBox = "Showing permission box"
    static let cancel = "Cancel"
    static let setting = "Setting"
    static let replacePermission = "You already given location permision to app. Do you want to change it? Please modified it from settings at privacy -> location service -> %@"
    static let deniedPermission = "You are previously denied location permision to app. To change it? Please modified it from settings at privacy -> location service -> %@"
    static let samePermission = "Already allow permission for it"
    static let initialize = "OK"
    static let invalidGoogleKey = "Google key Not provided"
    static let invalidWoosmapKey = "Woosmap API key not provided"
    static let visitDeleted = "Deleted"
    static let zoiDeleted = "Deleted"
    static let locationDeleted = "Deleted"
    static let regionDeleted = "Deleted"
    static let invalidProfile = "Invalid profile"
    static let invalidPOIRadius = "POI Radius should be an integer or a string"
    static let invalidSFMCCredentials = "Credentials cannot be empty"
    static let requried_authenticationBaseURI = "Required key missing: authenticationBaseURI"
    static let requried_restBaseURI = "Required key missing: restBaseURI"
    static let requried_client_id = "Required key missing: client_id"
    static let requried_client_secret = "Required key missing: client_secret"
    static let requried_contactKey = "Required key missing: contactKey"
}
