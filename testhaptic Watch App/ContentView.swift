//
//  ContentView.swift
//  testhaptic Watch App
//
//  Created by sungkug_apple_developer_ac on 9/22/24.
//
import SwiftUI
import WatchKit

struct ContentView: View {
    @State private var tempo: Double = 120.0  // 템포 초기값 (BPM)
    @State private var selectedHapticType: WKHapticType = .click // 햅틱 타입
    @State private var timers: [DispatchSourceTimer] = []   // 여러 타이머를 관리할 배열
    @State private var isHapticActive = false // 햅틱이 활성화되었는지 확인
    @State private var currentBatchIndex = 0 // 현재 실행 중인 배치 인덱스

//    let beatTimes: [Double] = [0.0, 0.5, 1.0, 2.0, 2.5,
//                               3.0, 4.0, 5.0,
//                               8.0/*쉼표 1.0 추가*/,8.5, 9.0, 10.0, 10.5,
//                               11.0, 12.0, 13.0,
//                               15.0/*쉽표 1.0추가*/, 15.5, 16.0, 17.0, 17.5,
//                               18.0, 19.0, 20.0, 21.0,
//                               22.0, 24.0,
//                               26.0,
//                               30.0, 31.0, 32.0, 33.0,
//                               34.0, 35.0, 35.5, 36.0, 36.5, 37.0,
//                               38.0, 39.0, 40.0, 41.0,
//                               42.0, 43.0, 43.5, 44.0, 44.5, 45.0,
//                               46.0, 47.0, 48.0, 49.0,
//                               50.0, 51.0, 51.5, 52.0, 53.0,
//                               54.0,
//                               59.0/*쉼표 2.0 추가 + 쉼표 1.0 추가*/, 60.0, 60.5, 61.0,
//                               62.0, 62.5, 63.0, 63.5, 64.0, 64.5, 65.0,
//                               66,0, 66.5, 67.0, 67.5, 68.0, 68.5, 69.0,
//                               70.0, 70.5, 71.0, 71.5, 72.0, 72.5, 73.0, 73.5,
//                               74.0, 74.5, 75.0, 75.5, 76.0, 76.5, 77.0,
//                               79.0 /*쉼표 1.0추가*/, 80.0, 81.0,
//                               82.0 ]
    
                                //도돌이표A
    let beatTimes: [Double] = [0.5/*쉼표 1.0 추가*/, 0.5, 1.0, 0.5, 0.5,
                               1.0, 1.0, 3.0/*쉼표 1.0 추가*/,
                               0.5, 0.5, 1.0, 0.5, 0.5,
                               1.0, 1.0, 2.0/*쉽표 1.0추가*/,
                               1.5/*쉼표 1.0 추가*/, 0.5, 1.0, 0.5, 0.5,
                               1.0, 1.0, 1.0, 1.0,
                               2.0, 2.0,
                               4.0,
                               //도돌이표A
                               0.5/*쉼표 1.0 추가*/, 0.5, 1.0, 0.5, 0.5,
                               1.0, 1.0, 3.0/*쉼표 1.0 추가*/,
                               0.5, 0.5, 1.0, 0.5, 0.5,
                               1.0, 1.0, 2.0/*쉽표 1.0추가*/,
                               1.5/*쉼표 1.0 추가*/, 0.5, 1.0, 0.5, 0.5,
                               1.0, 1.0, 1.0, 1.0,
                               2.0, 2.0,
                               4.0,
                               //도돌이표A
                               1.0, 1.0, 1.0, 1.0,
                               1.0, 0.5, 0.5, 0.5, 0.5, 1.0,
                               1.0, 1.0, 1.0, 1.0,
                               1.0, 0.5, 0.5, 0.5, 0.5, 1.0,
                               1.0, 1.0, 1.0, 1.0,
                               1.0, 0.5, 0.5, 1.0, 1.0,
                               5.0/*쉼표 2.0 추가 + 쉼표 1.0 추가*/,
                               1.0, 0.5, 0.5, 1.0,
                               // 도돌이표 B
                               0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0,
                               0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0,
                               0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
                               0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0,
                               // 도돌이표 B
                               0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0,
                               0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 1.0,
                               0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 0.5,
                               0.5, 0.5, 0.5, 0.5, 0.5, 0.5, 2.0/*쉼표 1.0 추가*/,
                               // 도돌이표 B
                               1.0, 1.0, 1.0]

    
    var body: some View {
        ScrollView {
            VStack {
                Text("V5_Tempo: \(Int(tempo)) BPM")
                    .font(.headline)
                    .padding(.bottom, 10)

                Slider(value: $tempo, in: 40...240, step: 10) {
                    Text("Tempo")
                }
                .padding(.bottom, 10)

                Picker("Haptic Type", selection: $selectedHapticType) {
                    Text("Click").tag(WKHapticType.click)
                    Text("Notification").tag(WKHapticType.notification)
                    Text("Success").tag(WKHapticType.success)
                    Text("Failure").tag(WKHapticType.failure)
                    Text("Retry").tag(WKHapticType.retry)
                    Text("Start").tag(WKHapticType.start)
                    Text("Stop").tag(WKHapticType.stop)
                }
                .labelsHidden()
                .frame(height: 50)
                .padding(.bottom, 10)
                
                Text("메트로놈")
                    .font(.caption2)
                    .padding()

                Button(action: {
                    if isHapticActive {
                        stopHaptic()  // 햅틱 중지
                    } else {
                        startHapticWithTempo(tempo: tempo)  // 햅틱 시작
                    }
                }) {
                    Text(isHapticActive ? "Stop" : "Start")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)  // 버튼 크기를 화면에 맞춤
                        .background(isHapticActive ? Color.red : Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal) // 버튼 좌우 간격을 추가
                
                Text("Pick Me")
                    .font(.caption2)
                    .padding()
                Button(action: {
                    if isHapticActive {
                        stopHaptic()  // 햅틱 중지
                    } else {
                        startHapticWithHardCodedBeats(batchSize: 10)  // 10개씩 실행
                    }
                }) {
                    Text(isHapticActive ? "Stop" : "Start")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)  // 버튼 크기를 화면에 맞춤
                        .background(isHapticActive ? Color.red : Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal) // 버튼 좌우 간격을 추가
                
            }
            .padding()
        }
        .onDisappear {
            stopHaptic()  // 뷰가 사라질 때 타이머 정리
        }
    }
    
    // 템포에 따라 햅틱을 일정한 주기로 울리는 함수
    func startHapticWithTempo(tempo: Double) {
        stopHaptic()  // 이전 타이머가 있으면 정지

        // 햅틱 주기 계산 (60초를 BPM으로 나눔)
        let interval = 60.0 / tempo
        
        // DispatchSourceTimer를 사용하여 주기적으로 햅틱을 울림
        let timer = DispatchSource.makeTimerSource()
        timer.schedule(deadline: .now(), repeating: interval, leeway: .milliseconds(50))
        timer.setEventHandler {
            DispatchQueue.main.async {
                WKInterfaceDevice.current().play(self.selectedHapticType) // 선택된 햅틱 타입 적용
            }
        }
        timer.resume()
        timers.append(timer)
        
        isHapticActive = true
    }
    
    // 햅틱과 타이머를 중지하는 함수
    func stopHaptic() {
        // 배열에 저장된 모든 타이머를 해제
        for timer in timers {
            timer.cancel()
        }
        timers.removeAll()  // 배열 비우기
        isHapticActive = false
    }
    // 하드코딩된 비트 타이밍에 따라 배치로 나누어 타이머 실행
    func startHapticWithHardCodedBeats(batchSize: Int) {
        stopHaptic()  // 이전 타이머가 있으면 정지
        currentBatchIndex = 0 // 배치 인덱스 초기화
        isHapticActive = true
        scheduleNextBatch(batchSize: batchSize) // 첫 번째 배치 실행
    }
    //기존 스케쥴러
//    func startHapticWithHardCodedBeats() {
//         stopHaptic()  // 이전 타이머가 있으면 정지
//         var playtime = 0.0
//         var previousPlaytime = 0.0 // 이전 타이밍을 저장할 변수
//         
//         for beatTime in beatTimes {
//             // 현재 플레이 타임과 이전 플레이 타임의 간격을 계산
//             let interval = convertBeatTime(beatTime: beatTime)
//             print("현재 타이머 실행 시간: \(playtime), 이전 타이머와의 간격: \(interval)초")
//             
//             // 타이머 생성
//             let timer = Timer.scheduledTimer(withTimeInterval: playtime, repeats: false) { _ in
//                 WKInterfaceDevice.current().play(selectedHapticType)
//             }
//             
//             playtime += interval // 다음 플레이 타임으로 업데이트
//             previousPlaytime = playtime
//             timers.append(timer)
//         }
//         isHapticActive = true
//     }
    
    
    //정확도 높은 타이머 로직
//    func startHapticWithHardCodedBeats() {
//         stopHaptic()  // 이전 타이머가 있으면 정지
//         var playtime = 0.0
//         
//         for beatTime in beatTimes {
//             let interval = convertBeatTime(beatTime: beatTime)
//             print("현재 타이머 실행 시간: \(playtime), 이전 타이머와의 간격: \(interval)초")
//
//             // 타이머 생성
//             let timer = DispatchSource.makeTimerSource()
//             timer.schedule(deadline: .now() + playtime, leeway: .milliseconds(50))
//             timer.setEventHandler {
//                 DispatchQueue.main.async {
//                     WKInterfaceDevice.current().play(self.selectedHapticType)
//                 }
//             }
//             timer.resume()
//             
//             playtime += interval // 다음 플레이 타임으로 업데이트
//             timers.append(timer)
//         }
//         isHapticActive = true
//     }
    
    
    //timer가 밀리는 것 같아서 10개씩 나눠서 진행시켜봄
    func scheduleNextBatch(batchSize: Int) {
        let startIndex = currentBatchIndex * batchSize
        let endIndex = min(startIndex + batchSize, beatTimes.count)
        
        // 배치 내에서 타이머 실행
        var playtime = 0.0
        for i in startIndex..<endIndex {
            let beatTime = beatTimes[i]
            let interval = convertBeatTime(beatTime: beatTime)
            print("현재 타이머 실행 시간: \(playtime), 이전 타이머와의 간격: \(interval)초")

            let timer = DispatchSource.makeTimerSource()
            timer.schedule(deadline: .now() + playtime, leeway: .milliseconds(50))
            timer.setEventHandler {
                DispatchQueue.main.async {
                    WKInterfaceDevice.current().play(self.selectedHapticType)
                }
            }
            timer.resume()
            playtime += interval // 다음 플레이 타임으로 업데이트
            timers.append(timer)
        }

        // 다음 배치가 있는지 확인
        if endIndex < beatTimes.count {
            currentBatchIndex += 1
            let nextBatchDelay = playtime // 마지막 타이머까지의 시간
            let batchTimer = DispatchSource.makeTimerSource()
            batchTimer.schedule(deadline: .now() + nextBatchDelay, leeway: .milliseconds(50))
            batchTimer.setEventHandler {
                DispatchQueue.main.async {
                    print("나머지 실행: \(endIndex)부터")

                    self.scheduleNextBatch(batchSize: batchSize) // 다음 배치 실행
                }
            }
            batchTimer.resume()
            timers.append(batchTimer)
        } else {
            isHapticActive = false // 모든 배치가 완료된 경우
        }
    }
    
    func convertBeatTime(beatTime: Double) -> Double {
        var convertBeatTime = beatTime / (tempo / 60)/*기준 BPM 60*/
        
        return convertBeatTime
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
