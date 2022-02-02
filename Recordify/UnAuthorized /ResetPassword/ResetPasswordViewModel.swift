//
//  ResetPasswordViewModel.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 31.01.22.
//

import Foundation
import Firebase
import FirebaseAuth
import SwiftUI


class ResetPasswordViewModel {
    
    
    func sendResetRequest(email: String, completion: @escaping (String?) -> Void )  {
        var myError: String? = nil
        
        Auth.auth().createUser(withEmail: email, password: "12345qwe") { result, error in
            if result != nil {
                myError = "E-mail \(email) is not registered"
                Auth.auth().currentUser?.delete(completion: { error in
                    print(error?.localizedDescription)
                    completion(myError)
                })
                
            }
            
            if result == nil {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    guard let error = error else {return completion(nil)}
                    myError = error.localizedDescription
                    completion(myError)
                }
                
            }
           
        }
       
        
     
        
    }
    
}
