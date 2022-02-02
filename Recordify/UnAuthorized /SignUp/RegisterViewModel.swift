//
//  RegisterViewModel.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 26.01.22.
//

import Foundation
import FirebaseAuth

class RegisterViewModel {
    
    var email: String = ""
    var password: String = ""
    var confirm: String = ""
    var role: UserRole = .user
    
    let successMessage = "You successfully registered, please verify e-mail before logging in"
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
       
    }
    
    func validatePasswordMatch() -> Bool {
        return password == confirm
    }
    
    func validatePasswordStrength() -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    func validateAllTheFields () -> String {
        if email.isEmpty || password.isEmpty || confirm.isEmpty {
            return "Please fill all the requred fields"
        }
        if !validateEmail() {
            return "Email didn't pass validation"
        }
        if !validatePasswordMatch() {
            return "Passwords don't match"
        }
        if !validatePasswordStrength() {
            return "Password didn't pass validation"
        }
        return successMessage
    }
    
    func registerUser(completion: @escaping (String) -> Void) {
        
        if validateAllTheFields() == successMessage {
            Auth.auth().fetchSignInMethods(forEmail: email, completion: { [weak self]
                    (providers, error) in
                    if let error = error {
                        completion(error.localizedDescription)
                        return
                    } else if let _ = providers {
                        completion("E-mail address is already in use")
                        
                    } else {
                        guard let self = self else {return}
                        Auth.auth().createUser(withEmail: self.email, password: self.password) {result, error in
                            if error == nil {
                            Auth.auth().currentUser?.sendEmailVerification(completion: {[weak self] error in
                                if let error = error {
                                    completion(error.localizedDescription)
                                    return
                                }
                                guard let self = self else {return}
                                completion(self.successMessage)
                                guard let uid = Auth.auth().currentUser?.uid else {return}
                                UsersDB.writeUser(email: self.email, role: self.role, uid: uid)
                                return
                                
                            })
                            } else {
                                guard let error = error else {return}
                                completion(error.localizedDescription)
                                return
                            }
                            
                        }
                    }
                })
        } else {
            completion(validateAllTheFields())
        }

    }
    
    
    
}
