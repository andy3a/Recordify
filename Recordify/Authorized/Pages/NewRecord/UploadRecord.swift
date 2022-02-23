//
//  UploadRecord.swift
//  Recordify
//
//  Created by Andrew_Alekseyuk on 14.02.22.
//

import SwiftUI
import AVKit
import AVFoundation

struct UploadRecord: View {

    @State var recording = false
    @State var startDate =  Date()
    
    @ObservedObject var audioRecorder: AudioRecorder
    
    @State var isRecodingStarted = false
    
    var timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    var action: ((_ recording: Bool) -> Void)?
    
    let waveformView = WaveformLiveView()
    let audioURL = Bundle.main.url(forResource: "sample", withExtension: "mp3")!
    // configure and start AVAudioRecorder
    let recorder = AVAudioRecorder()
    

    // after all the other recording (omitted for focus) setup, periodically (every 20ms or so):
//    recorder.updateMeters() // gets the current value
//    let currentAmplitude = 1 - pow(10, recorder.averagePower(forChannel: 0) / 20)
//    waveformView.add(sample: currentAmplitude)

    var body: some View {
        VStack{
            //Spacer()
            TimerView(isTimerRunning: $recording, startTime: $startDate)
            RecordingsList(audioRecorder: audioRecorder)
        RecordButton(recording: $recording, action: { printsmth()})
            
                .padding(.bottom, 90)
       
            //WaveformImageViewUI(audioURL: audioURL, configuration: .init())
        
        }.onAppear {
            //recorder.isMeteringEnabled = true
        }.onDisappear {
            print("Delete recordings")
        }
        
        
    }

    func printsmth() {
        print("pressed")
        startDate = Date()
        if isRecodingStarted == false {
            audioRecorder.startRecording()
            self.isRecodingStarted = true
        } else {
            audioRecorder.stopRecording()
            self.isRecodingStarted = false
        }
    }
}

struct UploadRecord_Previews: PreviewProvider {
    static var previews: some View {
       UploadRecord(audioRecorder: AudioRecorder())
    }
}
