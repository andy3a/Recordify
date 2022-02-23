//
//  RecordButton.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 18.02.22.
//

import SwiftUI
struct RecordButton: View {
    
    @Binding var recording: Bool
    @State var flashingColor: Bool = false
    var action: () -> Void
    
    var body: some View {
        
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .foregroundColor(.gray)
                .frame(width: 65, height: 65)
            
            RoundedRectangle(cornerRadius: recording ? 8 : self.innerCircleWidth / 2)
                .foregroundColor(flashingColor ? .gray : .red)
                .frame(width: self.innerCircleWidth, height: self.innerCircleWidth)
                .animation(.linear(duration: 0.2))
        }
        
        .padding(20)
        .onTapGesture {
            withAnimation {
                self.recording.toggle()
                self.action()
                colorChange()
  
            }
        }
        
    }
    
    var innerCircleWidth: CGFloat {
        self.recording ? 32 : 55
    }
    
    private func colorChange() {
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { timer in
            self.flashingColor.toggle()
            if recording == false {
                self.flashingColor = false
                timer.invalidate()
            }
        }
    }
}

struct RecordButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            
            //            RecordButton(recording: false)
            //                .previewLayout(PreviewLayout.sizeThatFits)
            //                .previewDisplayName("not recording")
            //                .background(Color.gray)
            //
            //            RecordButton(recording: true)
            //                .previewLayout(PreviewLayout.sizeThatFits)
            //                .previewDisplayName("recording")
            //                .background(Color.gray)
            
            ZStack {
                Image("turtlerock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                HStack {
                    Spacer()
                    //RecordButton()
                }
            }
        }
    }
}
