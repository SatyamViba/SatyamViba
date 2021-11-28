//
//  LoocationManager.swift
//  Viba
//
//  Created by Satyam Sutapalli on 28/11/21.
//

import Foundation
import CoreLocation

class Location: NSObject {
    private let locationManager = CLLocationManager()

    static let manager = Location()
    private override init() {
        super.init()
        locationManager.delegate = self
    }

    var isLocationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled() && (locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse)
    }

    var askLocationPermission: Bool {
        return CLLocationManager.locationServicesEnabled() &&  locationManager.authorizationStatus == .notDetermined
    }

    func showPermissionForLocation() {
        locationManager.requestAlwaysAuthorization()
    }
}

extension Location: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        NotificationCenter.default.post(name: .locationPermissionStatus, object: nil)
    }

//    func locationManager(_ manager: CLLocationManager,
//                         didChangeAuthorization status: CLAuthorizationStatus) {   switch status {
//          case .restricted, .denied:
//             // Disable your app's location features
//
//
//
//          case .authorizedWhenInUse:
//             // Enable your app's location features.
//             enableMyLocationFeatures()
//             break
//
//          case .authorizedAlways:
//             // Enable or prepare your app's location features that can run any time.
//             enableMyAlwaysFeatures()
//             break
//
//          case .notDetermined:
//             break
//       }
//    }
}
