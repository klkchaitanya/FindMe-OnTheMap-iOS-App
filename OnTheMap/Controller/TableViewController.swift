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
        cell.studentLocationLabel?.text = "\(student.mediaURL ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = self.studentLocations[indexPath.row]
        var website = student.mediaURL ?? ""
        guard let url = URL(string: website), UIApplication.shared.canOpenURL(url) else{
            self.showAlert(title: "Invalid URL", message: "Cannot open website because of invalid url")
            return
        }
        UIApplication.shared.openURL(URL(string: website)!)
        
    }
}
