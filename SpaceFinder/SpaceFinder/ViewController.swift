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
import CoreData
import AzureData

struct location {
    
    static var latitude: Double = 0
    static var longitude: Double = 0
    
}

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var spaces: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    var table : MSSyncTable?
    var store : MSCoreDataStore?
    
    var document = CustomDocument()
    
    @IBOutlet weak var label: UILabel!
    
    lazy var fetchedResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RoomCapacity")
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
        
        // show only non-completed items
        fetchRequest.predicate = NSPredicate(format: "complete != true")
        
        // sort by item text
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        // Note: if storing a lot of data, you should specify a cache for the last parameter
        // for more information, see Apple's documentation: http://go.microsoft.com/fwlink/?LinkId=524591&clcid=0x409
        let resultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        resultsController.delegate = self;
        
        return resultsController
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let client = MSClient(applicationURLString: "https://spacee.azurewebsites.net")
//        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext!
//        self.store = MSCoreDataStore(managedObjectContext: managedObjectContext)
//        client.syncContext = MSSyncContext(delegate: nil, dataSource: self.store, callback: nil)
//        self.table = client.syncTable(withName: "RoomCapacity")
//
//        var error : NSError? = nil
//        do {
//            try self.fetchedResultController.performFetch()
//        } catch let error1 as NSError {
//            error = error1
//            print("Unresolved error \(error), \(error?.userInfo)")
//            abort()
//        }
//        //let indexPath = IndexPath()
//
//
//        let item = self.fetchedResultController.value(forKey: "Places") as! NSManagedObject
//        if let text = item.value(forKey: "text") as? String {
//            label.text = text
//        } else {
//            label.text = "????"
//        }
//
        AzureData.get (documentWithId: "1426b8fb-4114-4289-af31-4f930240d6e6", as: CustomDocument.self, inCollection: "MyCollection", inDatabase: "outDatabase") { r in
                if r.resource != nil {
                    self.document = r.resource!
                }
            }
        
        let text = String(document.analog)
        label.text? = text
        

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
    
    func centerOnUser() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            spaces.setRegion(region, animated: true)
            
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            spaces.showsUserLocation = true
            centerOnUser()
            locationManager.startUpdatingLocation()
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
        guard let location =  locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        spaces.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}


