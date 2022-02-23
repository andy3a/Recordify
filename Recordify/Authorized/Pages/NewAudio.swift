//
//  NewAudio.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 16.02.22.
//

import SwiftUI

struct NewAudio: View {
    
    class ViewModel: ObservableObject {
        @Published var random = Int.random(in: 0..<666)
        @Published var newRecord = ImageAttributes(withSFSymbol: "person")
        
    }
    @Environment(\.dismiss) var dismiss
   
    
    @ObservedObject private var viewModel = NewAudio.ViewModel()
    
    
    var body: some View {
        VStack{
        viewModel.newRecord.image
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text("\(viewModel.random)")
            Button("replace image") {
                viewModel.newRecord = placeholderImage
            }
        }
       
            
    }
}


struct Test321: View {
    
    @Binding public var random: Int
    @Binding public var image: ImageAttributes
    
    
    @State var isShowingPhotoSelectionSheet = false
    
    
    var body: some View {
        Text("\(random)")
        Button("replace image") {
            image = placeholderImage
        }
    }
}
        
        

struct NewAudio_Previews: PreviewProvider {
    
    static var previews: some View {
        NewAudio()
    }
}
