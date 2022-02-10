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
    @EnvironmentObject var session: SessionProperties
    
    var body: some View {
        
        VStack {
            session.avatar.image
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .shadow(radius: (session.avatar.originalImage == nil) ? 0 : 4)
                ZStack {
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2)
                        
                    Button("Show Record") {
                        record.toggle()
                    }
                    .sheet(isPresented: $record) {
                        SheetView(text: "Record")
                    }
                }
                .padding()
            ZStack {
                Rectangle()
                    .fill(Color.green)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 2)
               
                Button("Show upload") {
                    record.toggle()
                }
                .sheet(isPresented: $upload) {
                    SheetView(text: "upload")
                }
            }
            .padding()
            }
        .frame(alignment: .top)
        
    }
}


struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    var text: String
    
    var body: some View {
        Button(text) {
            dismiss()
        }
        .font(.title)
        .padding()
        .background(Color.black)
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}
