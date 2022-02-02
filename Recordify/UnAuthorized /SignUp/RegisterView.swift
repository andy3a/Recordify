//
//  RegisterView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 26.01.22.
//

import SwiftUI

struct RegisterView: View {
    
    @Environment(\.presentationMode) var presentation
    
    @State var userEmail: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    
    @State private var selectedRole: UserRole = .user
    let roles = UserRole.allCases
    
    @State var isRegisterInProgress = false
    @State var isRegisterButtonActive = false
    
    @State private var isShowingAlert = false
    
    let viewModel = RegisterViewModel()
    
    @State var alertMessage = ""
    
    @State var error: String?
    
    var body: some View {
        VStack{
            Spacer()
                .frame(height: 30)
            VStack(alignment: .leading, spacing: 10) {
                Text("E-mail")
                TextField("E-mail", text: $userEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Password")
                TextField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Confirm the password")
                TextField("Confirm the password", text: $passwordConfirm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Choose your role")
                Picker("Role", selection: $selectedRole) {
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
                            putValuesInViewModel()
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
    
    func doSmth() {
        
    }
    
    func putValuesInViewModel() {
        viewModel.email = userEmail
        viewModel.password = password
        viewModel.confirm = passwordConfirm
        viewModel.role = selectedRole
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
