//
//  LoginViewModel.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 26.01.22.
//

import Foundation
import FirebaseAuth
import UIKit

class LoginViewModel: ObservableObject {
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isRegisterActive = false
    @Published var isSignInLoading = false
    @Published var isSuccessfullyLoggedIn = false
    @Published var isShowingAlert = false
    
    @Published var alertMessage: String = ""
    
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
                UsersDB.getCurrentUserRole {_ in
                    completion(nil)
                }
                
                return
            }
            
        }
    }
}
