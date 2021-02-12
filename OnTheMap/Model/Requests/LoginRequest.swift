//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/6/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation

struct LoginRequest: Codable{
    let udacity: Udacity
}

struct Udacity: Codable{
    let username: String
    let password: String
}
