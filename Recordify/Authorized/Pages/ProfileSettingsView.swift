//
//  ProfileSettingsView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 8.02.22.
//

import SwiftUI


struct ProfileSettingsView: View {
    
    @Binding public var imageAttributes: ImageAttributes
    
    @State var isShowingPhotoSelectionSheet = false

    var body: some View {
        VStack{
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
                        Text("changePhotoButtonLabel")
                            .font(.footnote)
                            .foregroundColor(Color.accentColor)
                    } else {
                        Text("addPhotoButtonLabel")
                            .font(.footnote)
                            .foregroundColor(Color.accentColor)
                    }
                })
                   
            }
            .fullScreenCover(isPresented: $isShowingPhotoSelectionSheet) {
                ImageMoveAndScaleSheet(imageAttributes: $imageAttributes)
            }
                       
            Button (action: {
                self.isShowingPhotoSelectionSheet = true
            }, label: {
                if imageAttributes.originalImage != nil {
                    Text("changePhotoButtonLabel")
                        .font(.footnote)
                        .foregroundColor(Color.accentColor)
                } else {
                    Text("addPhotoButtonLabel")
                        .font(.footnote)
                        .foregroundColor(Color.accentColor)
                }
            })
            
            Button {
                imageAttributes = placeholderImageTest
            } label: {
                Text("test")
            }

               
        }
        .fullScreenCover(isPresented: $isShowingPhotoSelectionSheet) {
            ImageMoveAndScaleSheet(imageAttributes: $imageAttributes)
        }
    }
    
    //            ImagePane(image: session.avatar,
    //                      isEditMode: $isEditMode,
    //                      renderingMode: renderingMode,
    //                      colors: colors)
    //                .frame(width: size, height: size)
    //                .foregroundColor(themeColor)
    
    
    
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

//struct ProfileSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileSettingsView(imageAttributes: )
//    }
//}
