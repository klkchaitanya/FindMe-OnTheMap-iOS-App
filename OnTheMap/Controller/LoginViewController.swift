//
//  ViewController.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/6/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func login(_ sender: Any) {
        print("Login")
        updateUI(login: true)
        UdacityClient.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://auth.udacity.com/sign-up")!)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        let FUNC_TAG = "handleLoginResponse"
        updateUI(login: false)
        if success {
            print("success: ", success)
            clearText()
            performSegue(withIdentifier: "RegularLogin", sender: nil)
            //TMDBClient.createSessionId(completion: handleSessionResponse(success:error:))
        } else {
            print(FUNC_TAG, " Error: ", error.debugDescription)
            showAlert(title: "Login Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateUI(login: false)
    }
    
    func updateUI(login: Bool){
        
        DispatchQueue.main.async {

        if(login){
            self.activityIndicator.startAnimating()
        }else{
            self.activityIndicator.stopAnimating()
        }
        
        self.activityIndicator.isHidden = !login
        self.usernameTextField.isEnabled = !login
        self.passwordTextField.isEnabled = !login
        self.loginButton.isEnabled = !login
        self.signUpButton.isEnabled = !login
            
        }
        
    }
    
    func clearText(){
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    


}

