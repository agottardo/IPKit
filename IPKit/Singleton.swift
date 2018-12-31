//
//  Singleton.swift
//  IPKit
//
//  Created by Andrea Gottardo on 2018-12-18.
//  Copyright © 2018 Andrea Gottardo. All rights reserved.
//

import Foundation
import CoreLocation

/**
 Entry point to the API. This must be used as a singleton, so
 make sure you always call `IPAPI.sharedInstance` to access this class.
 */
class IPAPI {
    
    /// Singleton instance...
    static let shared = IPAPI()
    /// ... so we provide a private initializer.
    private init() {}
    
    /// Timeout for network requests (default = 10 seconds).
    var timeout : TimeInterval = 10
    
    /**
    Sets a timeout for the network request to the API.
    */
    func setTimeout(seconds: TimeInterval) {
        timeout = seconds
    }
    
    /**
    Calls the API and obtains information regarding the current IP address.
     - Parameter completion: completion handler.
    */
    func fetch(completion: @escaping (_ response: IPResponse?, _ error: Error?) -> ()) {
        let endpoint = URL(string: "https://ipapi.co/json")!
        fetchFromAPI(requestURL: endpoint, completion: completion)
    }
    
    /**
     Calls the API and obtains information regarding the given IP address.
     - Parameter forIP: address to lookup.
     - Parameter completion: completion handler.
     */
    func fetch(forIP: String, completion: @escaping (_ response: IPResponse?, _ error: Error?) -> ()) {
        if !isValidIP(addr: forIP) {
            completion(nil, IPKitError.InvalidNameProvided)
            return
        }
        let endpoint = URL(string: "https://ipapi.co/" + forIP + "/json")!
        fetchFromAPI(requestURL: endpoint, completion: completion)
    }
    
    // - MARK: Network calls
    
    private func fetchFromAPI(requestURL: URL, completion: @escaping (IPResponse?, Error?) -> ()) {
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: requestURL, cachePolicy: URLRequest.CachePolicy.reloadRevalidatingCacheData, timeoutInterval: timeout)
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = false
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            do {
                let response = try self.parseResponse(responseData: data!)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        }
        task.priority = 1.0
        task.resume()
    }
    
    private func parseResponse(responseData: Data) throws -> IPResponse {
        do {
            let obj = try JSONSerialization.jsonObject(with: responseData, options: [])  as? [String:Any]
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
            return ipResponse
        } catch {
            throw error
        }
    }
    
    // - MARK: Error handling
    
    /**
    Returns whether `addr` is a valid IP address.
    */
    private func isValidIP(addr: String) -> Bool {
        
        let octets = addr.split(separator: ".")
        if octets.count != 4 {
            return false
        }
        
        for octet in octets {
            if octet.count > 3 || octet.count < 1 {
                return false
            }
            guard let asInt = Int(octet) else {
                return false
            }
            if asInt < 0 || asInt > 255 {
                return false
            }
        }
        
        return true

    }
    
}
