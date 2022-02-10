//
//  Purchases.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 9.02.22.
//

import SwiftUI

struct Purchases: View {
    
    
    
    @EnvironmentObject var session: SessionProperties
    
    
    
    
    var body: some View {
        
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
        
        Text("Yay, you are creator")
    }
    
}
