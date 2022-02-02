//
//  LoginViewModel.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 26.01.22.
//

import Foundation
import FirebaseAuth
import UIKit

class LoginViewModel {
    func logInUser(email: String, password: String, completion: @escaping (String?)-> Void) {
        print(email, password)
        if email == "" || password == "" {
            completion("Please fill the credentials")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error.localizedDescription)
                return
            }
            if Auth.auth().currentUser?.isEmailVerified == false {
                completion("Please verify your e-mail")
                return
            }
            if authResult != nil {
                UsersDB.getCurrentUserRole {
                    completion(nil)
                }
                
                return
            }
            
        }
    }
}
