//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/6/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation

class UdacityClient{
    
    struct Auth {
        static var sessionId: String? = nil
        static var key = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints{
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case userProfile
        
        var stringValue:String {
            switch self{
            case .login:
                return Endpoints.base + "/session"
            case .userProfile:
                return Endpoints.base + "/users/\(Auth.key)"
            }
        }
        
        var url:URL{
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password:String, completion: @escaping (Bool, Error?)->Void){
        let FUNC_TAG = "login"
        //let udacityBody = Udacity(username: username, password: password)
        let body = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        taskForPostRequest(url: Endpoints.login.url, responseType: LoginResponse.self, body: body){
            (response, error) in
            if let response = response {
                Auth.key = response.account.key
                Auth.sessionId = response.session.id
                getUserProfile(completion: {
                    (success, error) in
                    if(success)
                    {
                        print("User Profile fetched succesfully")
                    }
                })
                completion(true, nil)
            }else{
                completion(false, error)
            }
            
        }
    }
    
    class func getUserProfile(completion: @escaping (Bool, Error?)->Void){
        let FUNC_TAG = "getUserProfile"
        taskForGetRequest(url: Endpoints.userProfile.url, responseType: UserProfileResponse.self, body: ""){
            (response, error) in
            if let response = response{
                //success
                print(FUNC_TAG, " Success. Response: ", response)
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
            }else{
                //failure
                print(FUNC_TAG, " Failed", response)
            }
        }
    }
    
    
    class func logout(completion: @escaping ()->Void){
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if error != nil { // Handle error…
            return
        }
        let range = (5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
        print(String(data: newData!, encoding: .utf8)!)
        Auth.sessionId = ""
        completion()
        }
        
        task.resume()
    }
    
    
    
    class func taskForPostRequest<ResponseType: Decodable>(url:URL, responseType: ResponseType.Type, body: String, completion: @escaping (ResponseType?, Error?)->Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.data(using: String.Encoding.utf8) //try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
            
        }
        task.resume()
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body:String, completion: @escaping (ResponseType?, Error?)->Void){
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            guard let data = data else {
                DispatchQueue.main.async{
                    print("Error")
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let range = (5..<data.count)
                let newData = data.subdata(in: range) /* subset response data! */
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
}
