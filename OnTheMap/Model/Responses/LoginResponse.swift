//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/6/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation

struct LoginResponse: Codable{
    let account: Account
    let session: Session
}

struct Account: Codable{
    let registered: Bool
    let key: String
}

struct Session: Codable{
    let id: String
    let expiration: String
}
