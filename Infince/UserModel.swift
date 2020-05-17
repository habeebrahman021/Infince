//
//  User.swift
//  Infince
//
//  Created by Habeeb Rahman on 14/05/20.
//  Copyright © 2020 ZedOne. All rights reserved.
//

import Foundation

public struct UserModel: Codable {

    let name: String
    let email: String?

    enum CodingKeys: String, CodingKey {
        case name
        case email
    }

}
