//
//  ContentView.swift
//  testhaptic
//
//  Created by sungkug_apple_developer_ac on 9/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var PitchViewModel = PitchDetector()

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                Image(systemName: "music.note")
                    .imageScale(.large)
                    .foregroundStyle(.mint)
                Text("현재 음")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top)
                Text("\(PitchViewModel.note)")
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundStyle(.mint)
                    .padding(.top, 5)
                Text("현재 Hz ")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top)
                Text(String(format: "%0.2d", PitchViewModel.Hz))
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.top)
                
            }
            .padding()
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
