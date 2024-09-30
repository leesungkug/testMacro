//
//  PitchDetector.swift
//  testhaptic
//
//  Created by sungkug_apple_developer_ac on 9/24/24.
//

import SwiftUI
import AudioKit
import AudioKitEX
import SoundpipeAudioKit
import AVFoundation

class PitchDetector: ObservableObject {
    var microphone: AudioEngine.InputNode!
    var tracker: PitchTap!
    var engine: AudioEngine!
    var silence: Fader! // 엔진 출력을 위한 부스터 추가
    @Published var note: String = "측정 중"
    @Published var Hz: Float = 0.0
    
    // 강도 임계값 (0.0 ~ 1.0 사이 값, 1.0은 최대 강도)
    let amplitudeThreshold: AUValue = 0.1
    
    init() {
        engine = AudioEngine()
        
        // AudioEngine의 입력 노드를 초기화하기 전에 권한을 확인
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                self.setupAudioKit()
            } else {
                print("Microphone access denied")
            }
        }
    }
    
    private func setupAudioKit() {
        guard let input = engine.input else {
            print("Failed to get input node")
            return
        }
        
        microphone = input
        tracker = PitchTap(microphone) { pitch, amp in
            guard let frequency = pitch.first else { return }
            
            // 진폭이 임계값을 넘는 경우에만 처리
            if amp.first ?? 0 > self.amplitudeThreshold {
                self.processPitch(frequency: frequency)
            }
        }
        
        tracker.start()
        
        // 부스터를 엔진 출력에 연결
        silence = Fader(microphone, gain: 0)
        engine.output = silence
        
        do {
            try engine.start()
        } catch {
            print("Audio engine failed to start: \(error.localizedDescription)")
        }
    }
    
    func processPitch(frequency: AUValue) {
        // 주파수를 기반으로 음정 파악
        note = self.frequencyToNoteName(frequency: frequency)
        Hz = frequency
        print("Detected pitch: \(note) (\(frequency) Hz)")
    }
    
    func frequencyToNoteName(frequency: AUValue) -> String {
        // 주파수를 음정 이름으로 변환
        let noteNames = ["C(도)", "C#(도#)", "D(레)", "D#(레#)", "E(미)", "F(파)", "F#(파#)", "G(솔)", "G#(솔#)", "A(라)", "A#(라#)", "B(시)"]
        let semitone = 12 * log2(frequency / 440.0) + 69
        let noteIndex = Int(round(semitone)) % 12
        return noteNames[noteIndex]
    }
}
