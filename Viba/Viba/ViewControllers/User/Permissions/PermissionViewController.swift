//
//  PermissionViewController.swift
//  Viba
//
//  Created by Satyam Sutapalli on 28/11/21.
//

import UIKit
import AVFoundation

class PermissionViewController: UIViewController {
    @IBOutlet var locationPermissionStatus: VibaSwitch!
    @IBOutlet var cameraPermissionStatus: VibaSwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(updateLocationStatus), name: .locationPermissionStatus, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationPermissionStatus.isOn = Location.manager.isLocationServicesEnabled
        cameraPermissionStatus.isOn = (AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized)
    }

    @objc
    func updateLocationStatus() {
        locationPermissionStatus.isOn = Location.manager.isLocationServicesEnabled
    }

    @IBAction func handleCameraPermission(_ sender: Any) {
        if cameraPermissionStatus.isOn {
            if AVCaptureDevice.authorizationStatus(for: .video) != .denied {
                AVCaptureDevice.requestAccess(for: .video) { success in
                    if success { // if request is granted (success is true)

                    } else { // if request is denied (success is false)
                        // Create Alert
                        let alert = UIAlertController(title: "Camera", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)

                        // Add "OK" Button to alert, pressing it will bring you to the settings app
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }))
                        // Show the alert with animation
                        self.present(alert, animated: true)
                    }
                }
            } else {
                showInfo(message: "You disabled camera, please enable it from iPhone settings")
                cameraPermissionStatus.isOn = (AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized)
            }
        } else {
            showInfo(message: "You can disable the camera permission from device settings")
            cameraPermissionStatus.isOn = (AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized)
        }
    }

    @IBAction func handleLocationPermission(_ sender: Any) {
        if locationPermissionStatus.isOn {
            if Location.manager.askLocationPermission {
                Location.manager.showPermissionForLocation()
            } else {
                showInfo(message: "You can now enable the location permission from device settings only")
                locationPermissionStatus.isOn = Location.manager.isLocationServicesEnabled
            }
        } else {
            // Turning Off
            showInfo(message: "You can disable the location permission from device settings")
            locationPermissionStatus.isOn = Location.manager.isLocationServicesEnabled
        }
    }

    @IBAction func agreeTerms(_ sender: Any) {
        if cameraPermissionStatus.isOn && locationPermissionStatus.isOn {
            if let navController = navigationController {
                navController.popViewController(animated: true)
            }
        } else {
            showInfo(message: "You have to accept both location & camera permissions")
        }
    }
}
