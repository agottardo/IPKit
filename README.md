# 🌍 IPKit

IPKit is an easy-to-use framework for iOS/macOS that lets you interface seamlessly with `ipapi.co`, a commonly used service to obtain your IP address and some useful data related to it. With IPKit, you can go from this...

```shell
curl https://ipapi.co/8.8.8.8/json/
```
```json
{
    "ip": "8.8.8.8",
    "city": "Mountain View",
    "region": "California",
    "region_code": "CA",
    "country": "US",
    "country_name": "United States",
    "continent_code": "NA",
    "in_eu": false,
    "postal": "94035",
    "latitude": 37.386,
    "longitude": -122.0838,
    "timezone": "America/Los_Angeles",
    "utc_offset": "-0800",
    "country_calling_code": "+1",
    "currency": "USD",
    "languages": "en-US,es-US,haw",
    "asn": "AS15169",
    "org": "Google LLC"
}
```

... to this Swift beauty:

```swift
IPAPI.shared.fetch { (response, error) in
    let ipAddress   = response.ip                   // "8.8.8.8"
    let city        = response.location.city        // "Mountain View"
    let coordinates = response.location.coordinates // CLLocationCoordinate2D(37.386, -122.0838)
}
```
