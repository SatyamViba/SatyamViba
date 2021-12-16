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
    private var completionHandler: ((Result<CLLocation, Error>) -> Void)?

    static let manager = Location()
    private override init() {
        super.init()
        locationManager.delegate = self
    }

    var isLocationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled() && (locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse)
    }

    var askLocationPermission: Bool {
        return CLLocationManager.locationServicesEnabled() && locationManager.authorizationStatus == .notDetermined
    }

    func showPermissionForLocation() {
        locationManager.requestAlwaysAuthorization()
    }

    func fetchLocation(onCompletion handler: @escaping ((Result<CLLocation, Error>) -> Void)) {
        self.completionHandler = handler
        locationManager.requestLocation()
    }
}

extension Location: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        NotificationCenter.default.post(name: .locationPermissionStatus, object: nil)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let handler = completionHandler, let firstLocation = locations.first else {
            return
        }

        handler(.success(firstLocation))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let handler = completionHandler else {
            return
        }

        handler(.failure(error))
    }
}
