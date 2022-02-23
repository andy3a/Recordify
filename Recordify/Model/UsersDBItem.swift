//
//  UsersDBItem.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import Foundation

struct UsersDBItem: Codable {
    init(role: UserRole.RawValue, email: String, uid: String, userName: String? = "") {
        self.role = role
        self.email = email
        self.uid = uid
        self.userName = userName
        
    }
    //Retrieved during registration
    var role: UserRole.RawValue
    var email: String
    var uid: String
    //User-fills fields
    var userName: String?
    var userSurname: String?
    
    func returnRequeredProp(key: UserData) -> Any? {
        switch key {
        case .role:
            return role
        case .email:
            return email
        case .uid:
            return uid
        case .userName:
            return userName
        case .userSurname:
            return userSurname
       
        }
    }
}

