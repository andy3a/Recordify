//
//  ProfileView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 4.02.22.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var session: SessionProperties
    @State var profileImage: Image?
    @State var userName: String?
    
    @Binding var isLoggedIn: Bool?
    
    var body: some View {
        List {
            Section {
                NavigationLink(
                    destination: ProfileSettingsView(imageAttributes: $session.avatar),
                    label: {
                        HStack {
                            if let profileImage = profileImage {
                                profileImage
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                    .scaledToFill()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(Circle())
                                    .shadow(radius: (session.avatar.originalImage == nil) ? 0 : 4)
                            }

                            
                                
                            VStack (alignment: .leading, spacing: 10) {
                                if let userName = userName {
                                    Text(userName)
                                }
                                Text(session.email)
                                    .font(.system(size: 12))
                                    .accentColor(Color.pink)
                                
                            }
                            .padding()
                        }
                    })
                Text("Yay, you are creator")
            }
            Section {
                NavigationLink(
                    destination: Text("Your posts"),
                    label: {
                        Text("List of you posts")
                    })
                NavigationLink(
                    destination: Text("Sell statystics"),
                    label: {
                        Text("Sell statystics")
                    })
                NavigationLink(
                    destination: Purchases()
                        .navigationBarTitle("Purchases"),
                    label: {
                        Text("Your purchases")
                           
                    })
            }
            Section {
                ZStack(alignment: .leading) {
                    Button {
                        UsersDB.logOutUser {
                            
                            isLoggedIn = false
                        }
                    } label: {
                        Text("Log Out")
                            .foregroundColor(.red)
                    }
                }
            }
            Section {
                ZStack(alignment: .leading) {
                    Button {
                        UserDefaults.standard.removeObject(forKey: "userName")
                    } label: {
                        Text("Remove UD")
                            .foregroundColor(.red)
                    }
                }
            }
        }.onAppear {
            profileImage = session.avatar.image
            userName = session.userName
            session.avatar.objectWillChange.send()
        }
      
    }
    
    func showImage() {
        //image = Image("alex")
        if let decodedImage: UIImage = UIImage(data: session.imagestore) {
            profileImage = Image(uiImage: decodedImage)
            
           
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(isLoggedIn: .constant(true))
        
    }
}
