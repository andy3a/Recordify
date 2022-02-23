//
//  UploadArtwork.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 14.02.22.
//

import SwiftUI
let placeholder = ImageAttributes(withSFSymbol: "square.text.square.fill")

struct UploadArtwork: View {
    
   
    
    //@State var newRecord: ImageAttributes = placeholder2
    @Binding public var imageAttributes : ImageAttributes
    //@State public var imageAttributes = ImageAttributes(withSFSymbol: "square.text.square.fill")
    
    
    @State var isShowingPhotoSelectionSheet = false
    
   
    //@State var artwork: ImageAttributes = placeholder2
    
    var body: some View {
        
        
        
        VStack {
            Text("Please choose artwork")
            Button (action: {
                self.isShowingPhotoSelectionSheet = true
            }, label: {
                imageAttributes.image
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .scaledToFill()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Rectangle())
                    .shadow(radius: (imageAttributes.originalImage == nil) ? 0 : 4)
            })
            
            
        }
        .frame(width: UIScreen.main.bounds.width / 1.5, height: UIScreen.main.bounds.width / 1.5)
        .fullScreenCover(isPresented: $isShowingPhotoSelectionSheet) {
            ImageMoveAndScaleSheet(imageAttributes: .constant(imageAttributes), shape: .constant("Square"))
                }
       
        
        
        
        
        
    }
//        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
//
    
    
    
}

//struct UploadArtwork_Previews: PreviewProvider {
//    static var previews: some View {
//        UploadArtwork(imageAttributes: .constant(placeholderImage))
//    }
//}
