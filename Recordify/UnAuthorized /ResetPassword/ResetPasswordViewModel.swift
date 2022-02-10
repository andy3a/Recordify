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


class ResetPasswordViewModel: ObservableObject {
    
    @Environment(\.presentationMode) var presentation
    
    @Published var email: String = ""
    @Published var isRecoverLoading = false
    @Published var error: String?
    @Published var alertMessage = ""
    @Published var isShowingAlert = false
    
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
    func popView()  {
        self.presentation.wrappedValue.dismiss()
        
    }
}
