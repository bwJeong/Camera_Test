//
//  ContentView.swift
//  CameraTest
//
//  Created by Byungwook Jeong on 2021/11/14.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var cameraManager = CameraManager()
    
    var body: some View {
        ZStack {
            CameraPreview(cameraManager: cameraManager)
                .ignoresSafeArea()
        }
        .onAppear {
            cameraManager.check()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
