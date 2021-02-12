//
//  SubmitLocationViewController.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/8/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SubmitLocationViewController: UIViewController {
    
    @IBOutlet weak var mkMapView: MKMapView!
    @IBOutlet weak var btnFinishAddLocation: UIButton!
    @IBOutlet weak var websiteTextField: UITextField!
    
    var studentLocationInformation: StudentLocationInformation?

    override func viewDidLoad() {
        
        if let studentLocation = studentLocationInformation {
            let studentLocation = StudentLocation(
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ?? "",
                updatedAt: studentLocation.updatedAt ?? ""
            )
            showLocations(location: studentLocation)
        }
    }
    
    @IBAction func finishAddLocationClick(_ sender: Any) {
        print("Finish Adding Location...")

        if let studentLocation = studentLocationInformation{
            if UdacityClient.Auth.objectId == ""{
                ParseClient.postStudentLocation(information: studentLocation){
                    (success, error) in
                    if success{
                        DispatchQueue.main.async {
                            print("Succesfully posted student location...")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        DispatchQueue.main.async {
                            print("Error posting student location..!", error.debugDescription)
                        }
                    }
                }
            } else{
                print("Auth.objectId: ", UdacityClient.Auth.objectId)
                let alertVC = UIAlertController(title: "", message: "This student has already posted a location. Would you like to update this location?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "UPDATE", style: .default, handler: { (action: UIAlertAction) in
                    ParseClient.putStudentLocation(information: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                print("Succesfully updated student location...")
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                print("Error updating student location..!", error.debugDescription)
                                self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                            }
                        }
                    }
                }))
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        alertVC.dismiss(animated: true, completion: nil)
                    }
                }))
                self.present(alertVC, animated: true)
                
                
            }

        }else{
            print("Student Location Information is empty")
        }
    }
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    private func showLocations(location: StudentLocation) {
        mkMapView.removeAnnotations(mkMapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            //annotation.title = location.locationLabel
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mkMapView.addAnnotation(annotation)
            mkMapView.showAnnotations(mkMapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: StudentLocation) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(lat, lon)
        }
        return nil
    }
}
