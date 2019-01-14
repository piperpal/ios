//
//  DataViewController.swift
//  ios
//
//  Created by Ole Aamot on 1/14/19.
//  Copyright © 2019 Aamot Software. All rights reserved.
//

import UIKit
import MapKit

class DataViewController : UIViewController {
    let locationManager = CLLocationManager()
    @IBOutlet weak var dataLabel: UILabel!
    var dataObject: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}

extension DataViewController : CLLocationManagerDelegate {
   private func locationManager(locationManager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    private func locationManager(locationManager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location:: \(location)")
        }
    }
    
    private func locationManager(locationManager: CLLocationManager, didFailWithError error: NSError) {
        print("error:: \(error)")
    }
}

//class DataViewController: UIViewController {

//    let locationManager = CLLocationManager()

//    @IBOutlet weak var dataLabel: UILabel!
//    var dataObject: String = ""

  //  override func viewDidLoad() {
    //    super.viewDidLoad()

      //  locationManager.delegate = self
       // locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()

        // 1)
        // MapView.mapType = MKMapType.Standard
        
        // 2)
        //let location = CLLocationCoordinate2D(latitude: 23.0225,longitude:
        // 72.5714)
        
        // 3)
        //let span = MKCoordinateSpanMake(0.05, 0.05)
        //let region = MKCoordinateRegion(center: location, span: span)
        // MapView.setRegion(region, animated: true)
        
        // 4)
        //let annotation = MKPointAnnotation()
        //annotation.coordinate = location
        //annotation.title = "Piperpal"
        //annotation.subtitle = "FriendlyCoffeeShop"
        // MapView.addAnnotation(annotation)

        // Do any additional setup after loading the view, typically from a nib.
    //}

    //let regionRadius: CLLocationDistance = 1000
    //func centerMapOnLocation(location: CLLocation) {
    //    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
        //
// regionRadius, regionRadius)
        // MapView.setRegion(coordinateRegion, animated: true)
//    }
    
  //  override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    //}

    //override func viewWillAppear(_ animated: Bool) {
     //   super.viewWillAppear(animated)
     //   self.dataLabel!.text = dataObject
    //}
//}
