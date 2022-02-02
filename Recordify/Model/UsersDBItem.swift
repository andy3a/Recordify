//
//  UsersDBItem.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import Foundation

struct UsersDBItem: Decodable {
    init(role: UserRole.RawValue, email: String, uid: String) {
        self.role = role
        self.email = email
        self.uid = uid
    }
    
    var role: UserRole.RawValue
    var email: String
    var uid: String
}

