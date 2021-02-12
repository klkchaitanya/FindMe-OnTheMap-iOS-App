//
//  ViewController.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/6/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func login(_ sender: Any) {
        print("Login")
        usernameTextField.text = "chay.koravi@gmail.com"
        passwordTextField.text = "chaitusxperiaG0"
        UdacityClient.login(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpClick(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "https://auth.udacity.com/sign-up")!)
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        let FUNC_TAG = "handleLoginResponse"
        if success {
            print("success: ", success)
            performSegue(withIdentifier: "RegularLogin", sender: nil)
            //TMDBClient.createSessionId(completion: handleSessionResponse(success:error:))
        } else {
            print(FUNC_TAG, " Error: ", error)
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

