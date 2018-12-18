//
//  Structs.swift
//  IPKit
//
//  Created by Andrea Gottardo on 2018-12-18.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

struct IPResponse {
    var ip : String?
    var location : IPLocation?
    var asn : IPASNumber?
}

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
