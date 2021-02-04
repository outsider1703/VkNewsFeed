//
//  UserResponse.swift
//  VkNewsFeed
//
//  Created by Macbook on 04.02.2021.
//

import Foundation



struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
}
