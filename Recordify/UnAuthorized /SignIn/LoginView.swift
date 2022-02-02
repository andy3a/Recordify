//
//  LoginView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 25.01.22.
//

import SwiftUI

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State var isRegisterActive = false
    @State var isSignInLoading = false
    @State var isSuccessfullyLoggedIn = false
    @State private var isShowingAlert = false
    
    @State var alertMessage: String = ""
    
    let viewModel  = LoginViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack (alignment: .trailing) {
                Spacer()
                    .frame(height: 30)
                VStack(alignment: .leading, spacing: 10) {
                    Text("E-mail")
                    TextField("E-mail", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("Password")
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150, alignment: .top)
                .padding(.horizontal)
                
                NavigationLink(destination: ResetPasswordView()) {
                    Text("Reset password")
                        .foregroundColor(.pink)
                        .padding(.horizontal)
                }
 
                NavigationLink(destination:
                                UsersDB.currentUser?.role == "user"
                               ? AnyView(UserApp())
                               : AnyView(CreatorApp())
                                , isActive: $isSuccessfullyLoggedIn) {
                    Button {
                        isSignInLoading = true
                        
                        
                        viewModel.logInUser(email: username, password: password, completion: { result in
                            guard let result = result else {
                                UsersDB.getCurrentUserRole {
                                     isSuccessfullyLoggedIn = true
                                }
                               return
                            }
                            self.alertMessage = result
                            isSignInLoading = false
                            isShowingAlert = true
                        }
                        )
                        
                    } label: {
                        RoundedButton(text: "Sign In", bkColor: .systemBlue, isLoading: isSignInLoading)
                    }
                }
                .padding(.vertical)
                
                NavigationLink(destination:  RegisterView(), isActive: $isRegisterActive) {
                    Button {
                        isRegisterActive = true
                    } label: {
                        RoundedButton(text: "Register", bkColor: .systemMint, isLoading: false)
                    }
                }
            }
            
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .alert(alertMessage, isPresented: $isShowingAlert) {
                Button("OK", role: .cancel) { }
            }
            .transition(.asymmetric(insertion: .scale, removal: .move(edge: .bottom)))
        }
        .navigationBarHidden(true)
        .transition(.asymmetric(insertion: .scale, removal: .move(edge: .bottom)))
        
    }
        
    
    
    func chooseDestination() -> AnyView?  {
        guard let currentUser = UsersDB.currentUser else {return nil}
        guard let role = UserRole(rawValue: currentUser.role) else {return nil}
        switch role {
        case .creator:
            return AnyView(CreatorApp())
        case .user:
            return AnyView(UserApp())
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
