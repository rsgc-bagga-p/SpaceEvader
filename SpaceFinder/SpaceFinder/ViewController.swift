//
//  ViewController.swift
//  SpaceFinder
//
//  Created by Puneet Bagga on 2019-02-16.
//  Copyright © 2019 SpaceEvaders. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct location {
    
    static var latitude: Double = 0
    static var longitude: Double = 0
    
}

class ViewController: UIViewController {
    @IBOutlet weak var spaces: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func setupLocationManager() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
        
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            //Show that permission isnt given
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //Show an alert saying parental control
            break
        case .authorizedAlways:
            break
        }
        
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    }
    
    
}


