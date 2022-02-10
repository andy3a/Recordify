//
//  ResetPasswordView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 31.01.22.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @Environment(\.dismiss) var dismiss
    //@Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = ResetPasswordViewModel()
    
    var body: some View {
        
            VStack (alignment: .leading, spacing: 20) {
                Spacer()
                    .frame(height: 30)
                Text("Enter your e-mail")
                    .padding(.horizontal)
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Group {
                    NavigationLink(destination: LoginView(isLoggedIn: .constant(false))) {
                    Button {
                        viewModel.isRecoverLoading = true
                        viewModel.sendResetRequest(email: viewModel.email) { result in
                            if result == nil {
                                viewModel.alertMessage = "Please check you email and follow instructions"
                                viewModel.isShowingAlert = true
                            } else {
                                
                                viewModel.alertMessage = result!
                                viewModel.error =  viewModel.alertMessage
                                viewModel.isShowingAlert = true
                            }
                        }
                    } label: {
                        RoundedButton(text: "Send recover e-mail", bkColor: .systemBlue, isLoading: viewModel.isRecoverLoading)
                    }
                }
                    NavigationLink(destination: LoginView(isLoggedIn: .constant(false))) {
                    Button {
                        dismiss()
                        
                    } label: {
                        RoundedButton(text: "Cancel", bkColor: .systemRed)
                            
                    }
                }
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            
        
        
        
            .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK") {
                viewModel.isRecoverLoading = false
                guard  viewModel.error == nil else {
                    viewModel.email = ""
                    return}
                dismiss()
            }
        }
    }  
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
