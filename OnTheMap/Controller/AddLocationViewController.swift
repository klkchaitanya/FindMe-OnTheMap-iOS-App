//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/8/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var findLocation: UIButton!
    var objectId: String?
    
    @IBAction func cancelAddLocationClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationClick(_ sender: Any) {
        locationTextField.text = "Chicago, Illinois"
        websiteTextField.text = "https://www.udacity.com"
        print(locationTextField.text!)
        self.geocodePosition(newLocation: locationTextField.text!)
    }
    
    private func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) {
            (newMarker, error) in
            if let error = error {
                self.showLocationNotFound(message: error.localizedDescription, title: "Location not found")
                print("Location not found.")
            }
            else{
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                } else {
                    self.showLocationNotFound(message: "Please try again later!", title: "Error")
                    print("There was an error.")
                }
            }
        }
    }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SubmitLocationViewController") as! SubmitLocationViewController
        controller.studentLocationInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentLocationInformation {
        
        var studentLocationInformation = [
            "uniqueKey": UdacityClient.Auth.key,
            "firstName": UdacityClient.Auth.firstName,
            "lastName": UdacityClient.Auth.lastName,
            "mapString": locationTextField.text!,
            "mediaURL": websiteTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let objectId = objectId{
            studentLocationInformation["objectId"] = objectId as AnyObject
            print(objectId)
        }
        
        return StudentLocationInformation(studentLocationInformation)
        
    }
    
    func showLocationNotFound(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    
}
