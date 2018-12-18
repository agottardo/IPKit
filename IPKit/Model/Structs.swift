//
//  Structs.swift
//  IPKit
//
//  Created by Andrea Gottardo on 2018-12-18.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

/**
 A response returned by the ipapi.co API.
 */
struct IPResponse {
    /// The IP address of the device.
    var ip : String?
    /// Geographical data derived from the IP address.
    var location : IPLocation?
    /// Information about the Autonomous System the IP belongs to.
    var asn : IPASNumber?
}

/**
 Contains the geographical data derived from an IP address.
 */
struct IPLocation {
    var city : String?
    var region : String?
    var regionCode : String?
    var country : String?
    var countryName : String?
    var continentCode : String?
    var postalCode : String?
    var coordinates : CLLocationCoordinate2D?
    var timeZone : TimeZone?
    var countryCallingCode : String?
    var currency : String?
    var languages : [String]?
    var isInEuropeanUnion : Bool?
}

struct IPASNumber {
    var asNumber : String?
    var organizationName : String?
}
