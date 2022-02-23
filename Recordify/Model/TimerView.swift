//
//  TimerView.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 21.02.22.
//

import SwiftUI

struct TimerView: View {
    @Binding var isTimerRunning: Bool
    @Binding var startTime: Date
    @State var timerString = "00:00:00.00"
    
   let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()

    var body: some View {

        Text(self.timerString)
            .font(Font.system(.largeTitle, design: .monospaced))
            .onReceive(timer) { _ in
                if self.isTimerRunning {
                    
                    let time = Date().timeIntervalSince(startTime)
                    let hours = Int(time) / 3600
                    let minutes = Int(time) / 60 % 60
                    let seconds = Int(time) % 60
                    let miliseconds = Int(time * 100) % 60
                    timerString = String(format:"%02i:%02i:%02i.%02i", hours, minutes, seconds, miliseconds)
                }
            }
            
            
    }
}

//struct TimerView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimerView(isTimerRunning: .constant(true))
//    }
//}
