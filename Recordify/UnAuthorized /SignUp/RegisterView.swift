//
//  RegisterView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 26.01.22.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presentation
    
    let roles = UserRole.allCases
    
    @State var isRegisterInProgress = false
    @State var isRegisterButtonActive = false
    
    @State private var isShowingAlert = false
    
    @StateObject var viewModel = RegisterViewModel()
    
    @State var alertMessage = ""
    
    @State var error: String?
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 30)
            VStack(alignment: .leading, spacing: 10) {
                Text("E-mail")
                TextField("E-mail", text: $viewModel.userEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Password")
                TextField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Confirm the password")
                TextField("Confirm the password", text: $viewModel.passwordConfirm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Choose your role")
                Picker("Role", selection: $viewModel.selectedRole) {
                    ForEach(roles, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                Spacer()
                Group {
                    NavigationLink(destination:  RegisterView(), isActive: $isRegisterButtonActive) {
                        Button {
                            isRegisterInProgress = true
                            viewModel.registerUser {  result in
                                alertMessage = result
                                error = result
                                isShowingAlert = true
                            }
                            
                            
                        } label: {
                            RoundedButton(text: "Sign Up", bkColor: .systemBlue, isLoading: isRegisterInProgress)
                        }
                    }
                    
                    
                    
                    NavigationLink(destination:  RegisterView(), isActive: $isRegisterButtonActive) {
                        Button {
                            popView()
                        } label: {
                            RoundedButton(text: "Cancel", bkColor: .systemRed)
                                .padding(.vertical)
                        }
                    }
                    
                }
            }
            
            .padding()
        }
        .navigationBarHidden(true)
        .alert(alertMessage, isPresented: $isShowingAlert) {
            Button("OK") {
                isRegisterInProgress = false
                guard error == viewModel.successMessage else {return}
                popView()
            }
        }
    }
    
    func popView()  {
        self.presentation.wrappedValue.dismiss()
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
