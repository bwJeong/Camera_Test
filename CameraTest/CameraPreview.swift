//
//  CameraView.swift
//  CameraTest
//
//  Created by Byungwook Jeong on 2021/11/14.
//

import SwiftUI
import AVFoundation

// AVCaptureSession: 캡처 활동 관리, input의 data flow를 조정하여 output을 캡처하는 개체
// AVCaptureDeviceInput: capture session에 input data를 제공하는 개체(ex. 카메라, 마이크 등...)
// AVCapturePhotoOutput: 스틸 이미지, 라이브 포토, 기타 사진 워크 플로우에 대한 capture output

class CameraManager: ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { status in
                if status {
                    self.setup()
                }
            }
        case .denied:
            return
        case .authorized:
            setup()
            return
        default:
            return
        }
    }
    
    func setup() {
        do {
            // configuration 시작을 알림
            self.session.beginConfiguration()
            
            // - input, output에 대한 설정 - (Start)
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            // - input, output에 대한 설정 - (End)
            
            // configuration 종료를 알림 -> configuration 변경사항을 한꺼번에 적용
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)

        cameraManager.preview = AVCaptureVideoPreviewLayer(session: cameraManager.session)
        cameraManager.preview.frame = view.frame
        cameraManager.preview.videoGravity = .resizeAspectFill

        view.layer.addSublayer(cameraManager.preview)

        // 카메라 동작 시작
        cameraManager.session.startRunning()

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {

    }
}
