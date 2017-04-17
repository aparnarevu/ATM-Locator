//
//  ATMMapViewController.swift
//  ATMLocator
//
//  Created by Aparna Revu on 3/5/17.
//  Copyright © 2017 Aparna Revu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

struct Platform {
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
    }
}

class ATMMapViewController: UIViewController {

    @IBOutlet weak var mapView:MKMapView!
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (CLLocationManager.locationServicesEnabled())
        {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        self.mapView.delegate = self
        self.mapView.mapType = .standard
        self.mapView.isZoomEnabled = true
        self.mapView.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mapView.showsUserLocation = true

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - 
    //MARK: Utility methods
    
    func updateATMLoations(url:URL) {
        
        let userSession = URLSession(configuration: .default)
        
        let dataTask = userSession.dataTask(with: url, completionHandler: {
            data, response, error in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.updateLocations(data)
                }
            }
        })
        dataTask.resume()

    }
    
    func updateLocations(_ data: Data?) {
        
        do {
            let response = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
            if let errors: AnyObject = response["errors"] , errors.count > 0 {
                return
            }
            if let array: AnyObject = response[kLocationsKey] {
                for trackDictonary in array as! [AnyObject] {
                    if let annotationDictionary = trackDictonary as? [String: AnyObject] {
                        
                        let name = annotationDictionary[kNameKey] as! String!
                        let lat = Double(annotationDictionary[kLattitudeKey] as! String)
                        let lng = Double(annotationDictionary[kLongitudeKey] as! String)
                        
                        let distance = annotationDictionary[kDistanceKey] as! Double!
                        
                        let atmLocationInfo = ATMInfo()
                        atmLocationInfo.address = annotationDictionary[kAddressKey] as? String
                        atmLocationInfo.name = name
                        atmLocationInfo.distance = distance
                        atmLocationInfo.state = annotationDictionary[kStateKey] as? String
                        atmLocationInfo.city = annotationDictionary[kCityKey] as? String
                        atmLocationInfo.phone = annotationDictionary[kPhoneKey] as? String
                        atmLocationInfo.zip = annotationDictionary[kZipKey] as? String

                        if let hours = annotationDictionary[kLobbyHoursKey] {
                            // now hours is not nil and the Optional has been unwrapped, so use it
                            atmLocationInfo.lobbyHours = hours as? Array
                        }
                        let annotationCoord = CLLocationCoordinate2D(latitude: lat! , longitude: lng!)
                        let  locationPin = LocationPinAnnotaion(atmLocationInfo:atmLocationInfo)
                        
                        locationPin.coordinate = annotationCoord
                        locationPin.title = name
                        DispatchQueue.main.async {
                            self.mapView.addAnnotation(locationPin)
                        }
                    }

                }
            }
            
        } catch let error as NSError {
            print(error)
        }
    }

}

extension ATMMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("didFailWithError ",error.localizedDescription)
    }
}


extension ATMMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool){
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation){
        
        self.mapView.setCenter((userLocation.location?.coordinate)!, animated: true)
        let location = userLocation.location! as CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        if !Platform.isSimulator {
            region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        }
        
        //set region on the map
        self.mapView.setRegion(region, animated: true)
        let url:URL = URL(string: "\(kATMLocationsURLKey)lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)")!
        
        updateATMLoations(url: url)
        
    }
    

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.locationManager.stopUpdatingHeading()
    }
    
    // 1
    public func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? LocationPinAnnotaion {
            let identifier = "atmPin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView { // 2
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }
            
            return view
        }
        return nil
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedAnnotation = view.annotation as! LocationPinAnnotaion
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsView = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        detailsView?.selectedATM = selectedAnnotation.atmLocationInfo

        self.navigationController?.pushViewController(detailsView!, animated: true)
    }
    
}

