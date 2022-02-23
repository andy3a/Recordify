//
//  CreateView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 3.02.22.
//

import SwiftUI

struct CreateView: View {
    @State private var record = false
    @State private var upload = false
    
    
    var body: some View {
        
        VStack {
            
            
                ZStack {
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2)
                        
                    Button("New Record") {
                        record.toggle()
                    }
                    .sheet(isPresented: $record) {
                        NewRecord()
                    }
                }
                .padding()
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2)
               
                Button("New audio") {
                    upload.toggle()
                }
                .sheet(isPresented: $upload) {
                    NewAudio()
                }
            }
            .padding()
            }
        .frame(alignment: .top)
        
    }
}



struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
