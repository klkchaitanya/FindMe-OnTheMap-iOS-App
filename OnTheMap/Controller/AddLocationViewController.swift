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
    @IBOutlet weak var geocodeActivityIndicator: UIActivityIndicatorView!
    var objectId: String?
    
    override func viewDidLoad() {
        updateUI(geocoding: false)
    }
    
    @IBAction func cancelAddLocationClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationClick(_ sender: Any) {
        if(websiteTextField.text == ""){
            showAlert(title: "Website URL not found!", message: "Website URL is found empty. Please enter the website URL..")
        }else{
            updateUI(geocoding: true)
            self.geocodePosition(newLocation: locationTextField.text!)
        }
    }
    
    private func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) {
            (newMarker, error) in
            if let error = error {
                self.showAlert(title: "Location not found!", message: error.localizedDescription)
                print("Location not found.")
                self.updateUI(geocoding: false)
            }
            else{
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                    self.updateUI(geocoding: false)
                } else {
                    self.showAlert(title: "Error", message: "Problem loading location. Please try again later!")
                    print("There was an error.")
                    self.updateUI(geocoding: false)
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
    
    func updateUI(geocoding: Bool){
        DispatchQueue.main.async {
            self.geocodeActivityIndicator.isHidden = !geocoding
            if(geocoding){
                self.geocodeActivityIndicator.startAnimating()
            }else{
                self.geocodeActivityIndicator.stopAnimating();
            }
            self.locationTextField.isEnabled = !geocoding
            self.websiteTextField.isEnabled = !geocoding
            self.findLocation.isEnabled = !geocoding
        }
    }
    
    
}
