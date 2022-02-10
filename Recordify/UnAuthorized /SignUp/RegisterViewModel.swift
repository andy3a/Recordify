//
//  RegisterViewModel.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 26.01.22.
//

import Foundation
import FirebaseAuth

class RegisterViewModel: ObservableObject {
    
    @Published var userEmail: String = ""
    @Published var password: String = ""
    @Published var passwordConfirm: String = ""
    @Published var selectedRole: UserRole = .user
    
    @Published var isRegisterInProgress = false
    @Published var isRegisterButtonActive = false
    @Published var isShowingAlert = false
    @Published var alertMessage = ""
    @Published var error: String?
    
    let successMessage = "You successfully registered, please verify e-mail before logging in"
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: userEmail)
       
    }
    
    func validatePasswordMatch() -> Bool {
        return password == passwordConfirm
    }
    
    func validatePasswordStrength() -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordPred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    func validateAllTheFields () -> String {
        if userEmail.isEmpty || password.isEmpty || passwordConfirm.isEmpty {
            return "Please fill all the requred fields"
        }
        
        if !validatePasswordMatch() {
            return "Passwords don't match"
        }
        if !validateEmail() {
            return "Email didn't pass validation"
        }
        if !validatePasswordStrength() {
            return "Password didn't pass validation"
        }
        return successMessage
    }
    
    func registerUser(completion: @escaping (String) -> Void) {
        
        if validateAllTheFields() == successMessage {
            Auth.auth().fetchSignInMethods(forEmail: userEmail, completion: { [weak self]
                    (providers, error) in
                    if let error = error {
                        completion(error.localizedDescription)
                        return
                    } else if let _ = providers {
                        completion("E-mail address is already in use")
                        
                    } else {
                        guard let self = self else {return}
                        //move to separate func
                        Auth.auth().createUser(withEmail: self.userEmail, password: self.password) {result, error in
                            if error == nil {
                            Auth.auth().currentUser?.sendEmailVerification(completion: {[weak self] error in
                                if let error = error {
                                    completion(error.localizedDescription)
                                    return
                                }
                                guard let self = self else {return}
                                completion(self.successMessage)
                                guard let uid = Auth.auth().currentUser?.uid else {return}
                                UsersDB.writeUser(email: self.userEmail, role: self.selectedRole, uid: uid)
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
