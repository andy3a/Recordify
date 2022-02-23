//
//  ProfileSettingsView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 8.02.22.
//

import SwiftUI


struct ProfileSettingsView: View {
    
    @Binding public var imageAttributes: ImageAttributes
    
    @EnvironmentObject var session: SessionProperties
    
    @State var isShowingPhotoSelectionSheet = false

    var body: some View {
       
        ScrollView {
        VStack {
            VStack {
                imageAttributes.image
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .scaledToFill()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .shadow(radius: (imageAttributes.originalImage == nil) ? 0 : 4)
                Button (action: {
                    self.isShowingPhotoSelectionSheet = true
                }, label: {
                    if imageAttributes.originalImage != nil {
                        Text("change profile photo")
                            .font(.footnote)
                            .foregroundColor(Color.accentColor)
                    } else {
                        Text("add profile photo")
                            .font(.footnote)
                            .foregroundColor(Color.accentColor)
                    }
                })
                   
            
            }
            .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.width / 1.5)
            Text(session.uid)
            TextField("Name", text: $session.userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Surname", text: $session.userSurname)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            TextField("Nickname (optional)", text: Binding($session.nick) ?? .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
//            TextField("Bio (optional)", text: Binding($session.bio) ?? .constant(""))
//                .lineLimit(0)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
            
        }
                
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $isShowingPhotoSelectionSheet) {
            ImageMoveAndScaleSheet(imageAttributes: $imageAttributes, shape: .constant("Circle"))
        }
        .onAppear {
            print("Profile cropped")
        }
        .onDisappear {
            print("Profile new image cropped")
            session.avatar = imageAttributes
        }
        
        }

    
    }
    


extension ProfileSettingsView {
    class ViewModel: ObservableObject {
        @Published var symbolName: String = "person.crop.circle.fill"
        func update(_ image: ImageAttributes) {
            if symbolName != "avatar" {
                image.image = Image(systemName: symbolName.lowercased())
            }
        }
    }
}
