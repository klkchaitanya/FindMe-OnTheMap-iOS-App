//
//  UserProfileResponse.swift
//  OnTheMap
//
//  Created by Leela Krishna Chaitanya Koravi on 2/7/21.
//  Copyright © 2021 Leela Krishna Chaitanya Koravi. All rights reserved.
//

import Foundation
struct UserProfileResponse: Codable {
    let firstName: String
    let lastName: String
    let nickName: String
    
    enum CodingKeys: String, CodingKey{
        case firstName = "first_name"
        case lastName = "last_name"
        case nickName = "nickname"
    }
}
