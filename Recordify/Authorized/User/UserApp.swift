//
//  UserApp.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 1.02.22.
//

import SwiftUI
import FirebaseAuth


struct UserApp: View {
    @State var isActive = false
    @Binding var isLoggedIn: Bool?
//    init() {
//        UITabBar.appearance().isTranslucent = false
//        UITabBar.appearance().unselectedItemTintColor = UIColor(Color(uiColor: .label))
//        UITabBar.appearance().barTintColor = UIColor(Color.mint)
//
//    }
    
    var body: some View {

                TabView {
                    HomeView().tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    CreateView().tabItem {
                        Image(systemName: "mappin.circle.fill")
                        Text("Map")
                    }
                }
                .accentColor(.orange)
                
                //.edgesIgnoringSafeArea(.bottom)
            }
        }

//        NavigationView {
//            VStack {
//                Text(UsersDB.currentUser?.role ?? "error")
//            NavigationLink(destination:  LoginView(), isActive: $isActive) {
//                Button {
//                    let firebaseAuth = Auth.auth()
//                                        do {
//                                          try firebaseAuth.signOut()
//                                        } catch let signOutError as NSError {
//                                          print("Error signing out: %@", signOutError)
//                                        }
//                    isActive = true
//
//                } label: {
//                    RoundedButton(text: "Sign Out", bkColor: .systemBlue)
//                }
//            }
//            }
//            .navigationBarHidden(true)
//
       
//
    
       



//struct UserApp_Previews: PreviewProvider {
//    static var previews: some View {
//        UserApp(isLoggedIn: true, body: <#T##View#>)
//    }
//}
