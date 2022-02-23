//
//
//import Foundation
//import SwiftUI
//import AVKit
//
//
//public struct TextRec {
//    let waveformView = WaveformLiveView()
//
//    // configure and start AVAudioRecorder
//    let recorder = AVAudioRecorder()
//    recorder.isMeteringEnabled = true // required to get current power levels
//
//    // after all the other recording (omitted for focus) setup, periodically (every 20ms or so):
//    recorder.updateMeters() // gets the current value
//    let currentAmplitude = 1 - pow(10, recorder.averagePower(forChannel: 0) / 20)
//    waveformView.add(sample: currentAmplitude)
//}
//
//
//
//public struct WaveformLiveViewUI: UIViewRepresentable {
//    let audioURL: URL
//    let configuration: Waveform.Configuration
//
//    public init(audioURL: URL, configuration: Waveform.Configuration) {
//        self.audioURL = audioURL
//        self.configuration = configuration
//    }
//
//    public func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//
//    public func makeUIView(context: Context) -> UIView {
//        let waveformView = WaveformImageView(frame: .zero)
//        waveformView.configuration = configuration
//        waveformView.waveformAudioURL = audioURL
//        context.coordinator.waveformView = waveformView
//        return waveformView
//    }
//
//    public func updateUIView(_ uiView: UIView, context: Context) {
//        let waveformView = context.coordinator.waveformView!
//        waveformView.configuration = configuration
//        //waveformView.waveformAudioURL = audioURL
//    }
//
//    public class Coordinator: NSObject {
//        var waveformView: WaveformLiveView!
//
//        override init() {}
//    }
//}
