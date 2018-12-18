//
//  Singleton.swift
//  IPKit
//
//  Created by Andrea Gottardo on 2018-12-18.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

class IPAPI {
    
    private init() {}
    static let shared = IPAPI()

    let endpoint = URL(string: "https://ipapi.co/json")!
    var timeout : TimeInterval = 10
    
    func setTimeout(seconds: TimeInterval) {
        timeout = seconds
    }
    
    func fetch(completion: @escaping (IPResponse?, Error?) -> ()) {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: endpoint, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: timeout)
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = false
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            do {
                let obj = try JSONSerialization.jsonObject(with: data!, options: [])  as? [String:Any]
                var ipResponse = IPResponse()
                ipResponse.ip = obj?["ip"] as? String
                var location = IPLocation()
                var languages = [String]()
                (obj?["languages"] as? String)?.split(separator: ",").forEach({ (s) in
                    languages.append(String(s))
                })
                location.languages = languages
                location.country = obj?["country"] as? String
                location.countryName = obj?["country_name"] as? String
                location.city = obj?["city"] as? String
                location.currency = obj?["currency"] as? String
                location.continentCode = obj?["continent_code"] as? String
                location.countryCallingCode = obj?["country_calling_code"] as? String
                location.region = obj?["region"] as? String
                location.regionCode = obj?["region_code"] as? String
                location.postalCode = obj?["postal"] as? String
                location.isInEuropeanUnion = obj?["in_eu"] as? Bool
                if let lat = obj?["latitude"] as? Double, let lon = obj?["longitude"] as? Double {
                    let latLon = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    location.coordinates = latLon
                }
                var asn = IPASNumber()
                asn.asNumber = obj?["asn"] as? String
                asn.organizationName = obj?["org"] as? String
                if asn.asNumber != nil {
                    ipResponse.asn = asn
                }
                ipResponse.location = location
                completion(ipResponse, error)
            } catch {
                completion(nil, error)
            }
            
        }
        task.priority = 1.0
        task.resume()
    }
}
