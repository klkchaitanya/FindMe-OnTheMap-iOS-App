//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/7/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation

class ParseClient{
    

enum Endpoints{
    
    static let base = "https://onthemap-api.udacity.com/v1/StudentLocation"
    
    case getStudentLocations
    case postStudentLocation
    case putStudentLocation
    
    var stringValue: String {
        switch self{
        case .getStudentLocations:
            return Endpoints.base+"?limit=100&order=-updatedAt"
            
        case .postStudentLocation:
            return Endpoints.base
            
        case .putStudentLocation:
            return Endpoints.base + "/" + UdacityClient.Auth.objectId
        }
    }
    
    var url:URL{
        return URL(string: stringValue)!
    }
}

class func getStudentLocations(completion: @escaping ([StudentLocationInformation]?, Error?)->Void){
    let FUNC_TAG = "getStudentLocations"
    taskForGetRequest(url: Endpoints.getStudentLocations.url, responseType: StudentLocationResponse.self, body: ""){
        (response, error) in
        if let response = response{
            //success
            print(FUNC_TAG, " Success. Response: ", response)
            completion(response.results, nil)
        }else{
            //failure
            print(FUNC_TAG, " Failed", response)
            completion([], error)
        }
        }
    }
    
class func postStudentLocation(information: StudentLocationInformation, completion: @escaping (Bool, Error?)->Void){
        //Create new student location.
        print("postStudentLocation")
        let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"

        taskForPostRequest(url: Endpoints.postStudentLocation.url, responseType: PostLocationResponse.self, body: body, httpMethod: "POST"){
            (response, error) in
            if let response = response, response.createdAt != nil {
                UdacityClient.Auth.objectId = response.objectId ?? ""
                print("New Student Location posted successfully")
                completion(true, nil)
            }
            print("Student Location post failed. ", error.debugDescription)
            completion(false, error)
    }
}
    
class func putStudentLocation(information: StudentLocationInformation, completion: @escaping (Bool, Error?)->Void){
    //Update existing student location.
    print("putStudentLocation")
    print("student information: ", information)
    
    let body = "{\"uniqueKey\": \"\(information.uniqueKey ?? "")\", \"firstName\": \"\(information.firstName)\", \"lastName\": \"\(information.lastName)\",\"mapString\": \"\(information.mapString ?? "")\", \"mediaURL\": \"\(information.mediaURL ?? "")\",\"latitude\": \(information.latitude ?? 0.0), \"longitude\": \(information.longitude ?? 0.0)}"

    taskForPostRequest(url: Endpoints.putStudentLocation.url, responseType: PutLocationResponse.self, body: body, httpMethod: "PUT"){
        (response, error) in
        if let response = response, response.updatedAt != nil{
            print("Student Location updated successfully")
            completion(true, nil)
        }
        print("Student Location update failed. ", error.debugDescription)
        completion(false, error)
    }
}
    
    
    
class func taskForGetRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body:String, completion: @escaping (ResponseType?, Error?)->Void){
    let FUNC_TAG = "taskForGetRequest"
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request){
        data, response, error in
        guard let data = data else {
            DispatchQueue.main.async{
                completion(nil, error)
            }
            return
        }
        let decoder = JSONDecoder()
        do{
            let responseObject = try decoder.decode(ResponseType.self, from: data)
            DispatchQueue.main.async {
                print( FUNC_TAG, "responseObject: ", responseObject)
                completion(responseObject, nil)
            }
        }catch{
            DispatchQueue.main.async {
                print( FUNC_TAG, "error: ", error)
                completion(nil, error)
            }
        }
    }
    task.resume()
}
    
    class func taskForPostRequest<ResponseType: Decodable>(url:URL, responseType: ResponseType.Type, body: String, httpMethod: String, completion: @escaping (ResponseType?, Error?)->Void){
        let FUNC_TAG = "taskForPostRequest"
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = body.data(using: String.Encoding.utf8) //try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request){
            data, response, error in
            if error != nil {
                print(FUNC_TAG, "error: ", error)
                completion(nil, error)
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    print(FUNC_TAG, "error: ", error)
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do{
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    print(FUNC_TAG, "responseObject: ", responseObject)
                    completion(responseObject, nil)
                }
            }catch{
                DispatchQueue.main.async {
                    print(FUNC_TAG, "error: ", error)
                    completion(nil, error)
                }
            }
            
        }
        task.resume()
    }

}
