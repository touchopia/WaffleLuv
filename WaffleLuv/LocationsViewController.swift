//
//  LocationsViewController.swift
//  SimpleUserLocation
//
//  Created by Bronson Dupaix on 4/11/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import WebKit

class LocationsViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocationCoordinate2D(latitude: 40.760779, longitude: -111.891047)
    var webView = WKWebView()
    
    var trucksAreShown = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addTrucks), name: "TRUCKS_FOUND", object: nil)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        self.updateLocationTapped()
        
        
        if self.revealViewController() != nil {
            navButton.target = self.revealViewController()
            navButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if DataStore.sharedInstance.numberOfEvents() > 0 && trucksAreShown == false {
            addTrucks()
        }
        
    }
    
    func addTrucks() {
        
        print("addTrucks called")
        
        trucksAreShown = true
        
        createStorePins()
        
        let eventsArray = DataStore.sharedInstance.currentEventsArray
        
        for event in eventsArray {
            let coordinate = CLLocationCoordinate2D(latitude: event.latitiude, longitude: event.longitude)
            let subTitle = "\(event.startDate.toShortTimeString())-\(event.endDate.toShortTimeString())"
            createAnnotation(event.location, subTitle: subTitle, coordinate: coordinate)
        }
        centerMap(self.currentLocation)
    }
    
    @IBAction func updateLocationTapped() {
        
        let status = CLAuthorizationStatus.AuthorizedWhenInUse
        
        if status != .Denied {
            self.mapView.showsUserLocation = false
            self.locationManager.requestLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        self.updateLocationTapped()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            let location = locations.first
            print(location?.coordinate.latitude)
            print(location?.coordinate.longitude)
            
            // Find the Center Coordinate
            //if let center = location?.coordinate {
            centerMap(self.currentLocation)
            //self.currentLocation = center
            //}
        }
        print("location updated")
    }
    
    func centerMap(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.mapView.setRegion(region, animated: true)
        self.mapView.showsUserLocation = false
        print("mapView centered")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func createAnnotation(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        let annotation = CustomPointAnnotation()
        annotation.title = title
        annotation.subtitle = subTitle
        annotation.coordinate = coordinate
        annotation.imageName = "truck"
        
        if self.mapView != nil {
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let detailButton: UIButton = UIButton(type: UIButtonType.DetailDisclosure)
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        
        if annotationView == nil
        {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView?.canShowCallout = true
            
            let truckImage = UIImageView(frame: CGRectMake(0,0,32,32))
            truckImage.image = UIImage(named: "store")
            annotationView?.image = truckImage.image
            annotationView?.rightCalloutAccessoryView = detailButton
        } else {
            annotationView?.annotation = annotation
        }
        
        if let cpa = annotation as? CustomPointAnnotation {
            annotationView?.image = UIImage(named:cpa.imageName)
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        if let location = view.annotation!.title {
            if let time = view.annotation!.subtitle {
                self.directionsToLocation(location!, time: time!)
            }
        }
    }
    
    //MARK: - Locations Manager functions and Center map
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createStorePins() {
        
        let midvale = CustomPointAnnotation()
        
        let provo = CustomPointAnnotation()
        
        let bountiful = CustomPointAnnotation()
        
        let gilbert = CustomPointAnnotation()
        
        gilbert.coordinate = CLLocationCoordinate2D(latitude: 33.300539, longitude: -111.743183)
        gilbert.imageName = "store"
        gilbert.title = "2743 S Market St #104, Gilbert, AZ 85295"
        gilbert.subtitle = "Gilbert AZ Location"
        
        midvale.coordinate = CLLocationCoordinate2D(latitude: 40.623698, longitude: -111.860071)
        midvale.imageName = "store"
        midvale.title =  "1142 Fort Union Blvd #M05, Midvale, UT 84047"
        midvale.subtitle = "Midvale Location"
        
        provo.coordinate = CLLocationCoordinate2D(latitude: 40.258434, longitude: -111.674773)
        
        provo.imageName = "store"
        provo.title = "1796 N 950 W St, Provo, UT 84604"
        provo.subtitle = "Provo Location"
        
        bountiful.coordinate = CLLocationCoordinate2D(latitude: 40.891752, longitude: -111.892615)
        bountiful.imageName = "store"
        bountiful.title =  "255 North 500 West, Bountiful, UT 84010"
        bountiful.subtitle = "Bountiful Location"
        
        self.mapView.addAnnotation(midvale)
        self.mapView.addAnnotation(provo)
        self.mapView.addAnnotation(bountiful)
        self.mapView.addAnnotation(gilbert)
    }
    
    //MARK: - Directions Alert View
    
    func directionsToLocation(location: String, time: String ) {
        
        //  print("Annotation Tapped")
        
        let alertController = UIAlertController(title: "\(location)", message: "Take Me To This Location", preferredStyle: .Alert)
        
        let directionsAction = UIAlertAction(title: "Directions", style: .Default) { (alertAction) -> Void in
            
            print("Directions Pressed")
            
            if let escapedString = location.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) {
                
                let urlString = "https://www.google.com/maps/place/\(escapedString)"
                
                if let url = NSURL(string: urlString) {
                    print("opening url")
                    UIApplication.sharedApplication().openURL(url)
                }
            } else {
                print("could not escape \(location)")
            }
        }
        
        alertController.addAction(directionsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    
}