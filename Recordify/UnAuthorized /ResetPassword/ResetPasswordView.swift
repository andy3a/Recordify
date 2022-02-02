//
//  ResetPasswordView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 31.01.22.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @State var email: String = ""
    @State var isRecoverLoading = false
    
    
    let viewModel = ResetPasswordViewModel()
    
    @State var error: String?
    @State var alertMessage = ""
    @State private var isShowingAlert = false
    
    var body: some View {
        
            VStack (alignment: .leading, spacing: 20) {
                Spacer()
                    .frame(height: 30)
                Text("Enter your e-mail")
                    .padding(.horizontal)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Group {
                NavigationLink(destination:  LoginView()) {
                    Button {
                        isRecoverLoading = true
                        viewModel.sendResetRequest(email: email) { result in
                            if result == nil {
                                alertMessage = "Please check you email and follow instructions"
                                isShowingAlert = true
                            } else {
                                
                                alertMessage = result!
                                error = alertMessage
                                isShowingAlert = true
                            }
                        }
                    } label: {
                        RoundedButton(text: "Send recover e-mail", bkColor: .systemBlue, isLoading: isRecoverLoading)
                    }
                }
                NavigationLink(destination:  LoginView()) {
                    Button {
                        popView()
                    } label: {
                        RoundedButton(text: "Cancel", bkColor: .systemRed)
                            
                    }
                }
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            
        
        
        
        .alert(alertMessage, isPresented: $isShowingAlert) {
            Button("OK") {
                isRecoverLoading = false
                guard error == nil else {
                    email = ""
                    return}
                popView()
            }
        }
    }
    
    func popView()  {
        self.presentation.wrappedValue.dismiss()
        
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
