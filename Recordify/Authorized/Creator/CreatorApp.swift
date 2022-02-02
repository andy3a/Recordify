//
//  UserApp.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import SwiftUI
import FirebaseAuth


struct CreatorApp: View {

    
    
    @State var isActive = false
    
    var body: some View {

        NavigationView{
            VStack {
                Text(UsersDB.currentUser?.role ?? "error")
                Button("Hello") {
                    NavigationLink(destination: LoginView()) {
                        Text("WHAAAT")
                    }
                }
               
            NavigationLink(destination:  LoginView(), isActive: $isActive) {
                Button {
                    let firebaseAuth = Auth.auth()
                                        do {
                                          try firebaseAuth.signOut()
                                        } catch let signOutError as NSError {
                                          print("Error signing out: %@", signOutError)
                                        }
                    isActive = true
                    
                } label: {
                    RoundedButton(text: "Sign Out", bkColor: .systemBlue)
                
            }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            }
            
        }
        
    }
       
}

struct CreatorApp_Previews: PreviewProvider {
    static var previews: some View {
        CreatorApp()
    }
}
