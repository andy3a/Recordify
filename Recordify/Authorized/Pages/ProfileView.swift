//
//  ProfileView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 4.02.22.
//

import SwiftUI

class VM {
    
}

struct ProfileView: View {
    
//    class viewModel: ObservableObject {
//        @Published var sessionProperties: SessionProperties
//        init(sessionProperties: SessionProperties) {
//            self.sessionProperties = sessionProperties
//        }
//    }
    
    //@ObservedObject var viewModel: VM

    @Binding var isLoggedIn: Bool?
    @EnvironmentObject var session: SessionProperties
//    @Binding public var imageAttributes: ImageAttributes
    
    //@ObservedObject var localVar: SessionProperties
   
    
//    init() {
//        _viewModel
//    }
    
    
    @State var image = placeholderImage.image
    
    
    var body: some View {
        List {
            Section {
                NavigationLink(
                    destination: ProfileSettingsView(imageAttributes: $session.avatar),
                    label: {
                        HStack {
                            session.avatar.image
                                .resizable()
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                .scaledToFill()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .shadow(radius: (session.avatar.originalImage == nil) ? 0 : 4)
                                
                            VStack (alignment: .leading, spacing: 10) {
                                Text("Alex")
                                Text("4andailer@gmail.com")
                                
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
                Button {
                  
                        showImage()
                    
                    
                } label: {
                    Text("load")
                }

                session.avatar.image
                    .frame(width: 50, height: 50)
            }
            Section {
                
                Image(uiImage: UIImage(data: session.imagestore)!)
                    .frame(width: 100, height: 100)
            }
            Section {
                VStack {
                Text(session.test)
                    Button {
                        session.test = session.test + "\(1)"
                        let image = UIImage(named: "alex")
                         
                        // Encode and store image
                        
                        if let data = image!.pngData() {
                            session.imagestore = data
                            print(session.imagestore)
                            showImage()
                        
                        }
                        
                        
                    } label: {
                    Text("add one")
                    }

                }
                    
            }
            
        }.onAppear {
            print(session.avatar.scale)
            print(session.avatar)
            print(session.avatar.originalImage)
        }
      
    }
    
    func showImage() {
        //image = Image("alex")
        if let decodedImage: UIImage = UIImage(data: session.imagestore) {
             image = Image(uiImage: decodedImage)
            
           
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ProfileView(isLoggedIn: .constant(true))
                .preferredColorScheme(.dark)
            ProfileView(isLoggedIn: .constant(true))
        }
    }
}
