//
//  LoginView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 25.01.22.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var isLoggedIn: Bool?
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        
        NavigationView{
            VStack (alignment: .trailing) {
                Spacer()
                    .frame(height: 30)
                VStack(alignment: .leading, spacing: 10) {
                    Text("E-mail")
                    TextField("E-mail", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Password")
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150, alignment: .top)
                .padding(.horizontal)
                
                NavigationLink(destination: ResetPasswordView()) {
                    Text("Reset password")
                        .foregroundColor(.pink)
                        .padding(.horizontal)
                }
                
                
                Button {
                    viewModel.isSignInLoading = true
                    viewModel.logInUser(email: viewModel.username, password: viewModel.password, completion: { result in
                        guard let result = result else {
                            UsersDB.getCurrentUserRole { error in
                                guard let error = error else {
                                    isLoggedIn = true
                                    return
                                }
                                viewModel.alertMessage = error
                            }
                            return
                        }
                        viewModel.alertMessage = result
                        viewModel.isSignInLoading = false
                        viewModel.isShowingAlert = true
                    }
                    )
                    
                } label: {
                    RoundedButton(text: "Sign In", bkColor: .systemBlue, isLoading: viewModel.isSignInLoading)
                }
            
            .padding(.vertical)
            
                NavigationLink(destination:  RegisterView(), isActive: $viewModel.isRegisterActive) {
                Button {
                    viewModel.isRegisterActive = true
                } label: {
                    RoundedButton(text: "Register", bkColor: .systemMint, isLoading: false)
                }
            }
            }

        
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .alert(viewModel.alertMessage, isPresented: $viewModel.isShowingAlert) {
            Button("OK", role: .cancel) { }
        }
        .transition(.asymmetric(insertion: .scale, removal: .move(edge: .bottom)))
        
        .navigationBarHidden(true)
        .transition(.asymmetric(insertion: .scale, removal: .move(edge: .bottom)))
    
}
}
}




    func chooseDestination() -> Bool?   {
        guard let currentUser = UsersDB.currentUser else {return nil}
        guard let role = UserRole(rawValue: currentUser.role) else {return nil}
        return true
        
    
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(is)
//    }
//}
