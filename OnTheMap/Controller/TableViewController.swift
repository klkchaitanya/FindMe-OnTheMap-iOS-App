//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/7/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{
    
    
    let TAG = "TableViewController "
    @IBOutlet var studentLocationsTableView: UITableView!
    
    var studentLocations = [StudentLocationInformation]()
    
    override func viewDidAppear(_ animated: Bool) {
        let FUNC_TAG = "viewDidAppear "
        print(TAG, FUNC_TAG)
        //getStudentLocations
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
            self.studentLocations = locationResults ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell", for: indexPath) as! TableViewCell
        let student = self.studentLocations[indexPath.row]
        cell.studentNameLabel?.text = "\(student.firstName)" + " " + "\(student.lastName)"
        ///cell.detailTextLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.studentLocations[indexPath.row]
        var toOpen = student.mediaURL ?? ""
        if(toOpen == ""){
            showAlert(message: "This subject has no website setup!", title: "Unable to open URL")
        }else{
        UIApplication.shared.openURL(URL(string: toOpen)!)
        }
        
    }
    
    
    func showAlert(message: String, title: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}
