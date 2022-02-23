//
//  RoundedButton.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 27.01.22.
//

import SwiftUI

struct RoundedButton : View {
    let text: String
    let bkColor: UIColor
    var isLoading = false
    var isActive: Bool
    
    init(text: String,  bkColor: UIColor, isLoading: Bool = false, isActive: Bool = true) {
        self.text = text
        self.bkColor = bkColor
        self.isActive = isActive
        
    }

    var body: some View {
        
        let progressView = ProgressView()
            .frame(height: 40)
        let labelView = Text(text)
            .foregroundColor(.white)
            .bold()
            .navigationBarHidden(true)
            .frame(height: 40)
        HStack {
            Spacer()
            self.isLoading ?
            AnyView(progressView) : AnyView(labelView)
            Spacer()
        }
        .background(Color(uiColor: isActive ? bkColor: .gray))
        .cornerRadius(100)
        .padding(.horizontal)
    }
    
}

struct RoundedButton_Previews: PreviewProvider {
    
    static var previews: some View {
        RoundedButton(text: "Test", bkColor: .systemRed)
    }
}
