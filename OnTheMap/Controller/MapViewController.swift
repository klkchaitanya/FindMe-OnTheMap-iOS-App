//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/7/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    
    let TAG = "MapViewController "
    
    @IBOutlet weak var mkMapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()
    var studentLocations = [StudentLocationInformation]()

    override func viewDidAppear(_ animated: Bool) {
        let FUNC_TAG = "viewDidAppear "
        print(TAG, FUNC_TAG)
        getStudentLocations()
    }
    
    @IBAction func logout(_ sender: Any) {
        print("Logout click")
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        studentLocations = [StudentLocationInformation]()
        getStudentLocations()
    }
    
    func getStudentLocations(){
        ParseClient.getStudentLocations(){
            (locationResults, error) in
            guard let results = locationResults else{
                self.showAlert(title: "Problem getting student locations!", message: error?.localizedDescription ?? "")
                return
            }
            
            self.mkMapView.removeAnnotations(self.annotations)
            self.annotations.removeAll()
            self.studentLocations = locationResults ?? []
            
            for locationResult in locationResults ?? [] {
                let firstName = locationResult.firstName
                let lastName = locationResult.lastName
                let mapString = locationResult.mapString
                let mediaURL = locationResult.mediaURL
                let lat = CLLocationDegrees(locationResult.latitude ?? 0.0)
                let long = CLLocationDegrees(locationResult.longitude ?? 0.0)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

                print(firstName, " ",  lastName, " ", mapString)
                
                // Here we create the annotation and set its coordiate, title, and subtitle properties
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = mediaURL
                
                // Finally we place the annotation in an array of annotations.
                self.annotations.append(annotation)
            }
            
            DispatchQueue.main.async {
                self.mkMapView.addAnnotations(self.annotations)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let website = view.annotation?.subtitle! {
                guard let url = URL(string: website), UIApplication.shared.canOpenURL(url) else{
                    self.showAlert(title: "Invalid URL", message: "Cannot open website because of invalid url")
                    return
                }
                UIApplication.shared.openURL(URL(string: website)!)
            }else{
                self.showAlert(title: "Invalid URL", message: "Cannot open website because of invalid url")
            }
        }
    }
    
}
