//
//  testhapticApp.swift
//  testhaptic
//
//  Created by sungkug_apple_developer_ac on 9/22/24.
//

import SwiftUI

@main
struct testhapticApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                TabView {
                    // 첫 번째 탭: ContentView
                    ContentView()
                        .tabItem {
                            Image(systemName: "camera") // 아이콘 (적절한 아이콘으로 변경 가능)
                            Text("Camera") // 탭 제목
                        }
                    
                    // 두 번째 탭: ScanPDFView
                    ScanPDFView()
                        .tabItem {
                            Image(systemName: "doc.text.viewfinder") // 아이콘 (적절한 아이콘으로 변경 가능)
                            Text("Scan PDF") // 탭 제목
                        }
                }
                
            }
        }
    }
}
