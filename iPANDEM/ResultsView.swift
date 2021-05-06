//
//  ResultsView.swift
//  Camera view for image processing of a SalivaMAX test strip(s)
//
//  Created by Kevin Jurden on 3/15/21.
//

import SwiftUI
import AVFoundation

struct ResultsView: View {
    @Binding var showResults: Bool
    @StateObject var camera = CameraModel()
    
    var body: some View {
        ZStack {
            Color.black
            CameraPreview(camera: camera)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        self.showResults = false
                    }, label: {
                        Text("Home")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.white)
                            .clipShape(Capsule())
                    })
                    .padding(.trailing, 10)
                }
                /*ZStack {
                    GeometryReader { geometry in
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*2)-25, y: geometry.size.height/5*1.5))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*2)+25, y: (geometry.size.height)/5*1.5))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*2), y: (geometry.size.height/5*1.5)-25))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*2), y: (geometry.size.height/5*1.5)+25))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*2)-25, y: geometry.size.height/5*2.25))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*2)+25, y: (geometry.size.height)/5*2.25))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*2), y: (geometry.size.height/5*2.25)-25))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*2), y: (geometry.size.height/5*2.25)+25))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*2)-25, y: geometry.size.height/5*3))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*2)+25, y: (geometry.size.height)/5*3))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*2), y: (geometry.size.height/5*3)-25))
                            path.addLine(to: CGPoint(x:     (geometry.size.width/5*2), y: (geometry.size.height/5*3)+25))
                        }
                        .stroke(Color.white, lineWidth: 2)
                    }
                    GeometryReader { geometry in
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*3)-25, y: geometry.size.height/5*1.5))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*3)+25, y: (geometry.size.height)/5*1.5))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*3), y: (geometry.size.height/5*1.5)-25))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*3), y: (geometry.size.height/5*1.5)+25))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*3)-25, y: geometry.size.height/5*2.25))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*3)+25, y: (geometry.size.height)/5*2.25))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*3), y: (geometry.size.height/5*2.25)-25))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*3), y: (geometry.size.height/5*2.25)+25))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*3)-25, y: geometry.size.height/5*3))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*3)+25, y: (geometry.size.height)/5*3))
                        }
                        .stroke(Color.white, lineWidth: 2)
                        Path { path in
                            path.move(to: CGPoint(x: (geometry.size.width/5*3), y: (geometry.size.height/5*3)-25))
                            path.addLine(to: CGPoint(x: (geometry.size.width/5*3), y: (geometry.size.height/5*3)+25))
                        }
                        .stroke(Color.white, lineWidth: 2)
                    }
                }*/
                Spacer()
                Text("\(camera.resultsText)")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .onAppear(perform: {
                camera.Check()
            })
            .alert(isPresented: $camera.alert) {
                Alert(title: Text("Please Enable Camera Access"))
            }
        }
    }
}


struct ResultsView_Previews: PreviewProvider {
    @State static var showResults = true
    
    static var previews: some View {
        ResultsView(showResults: $showResults)
    }
}

class CameraModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var isTaken = false

    @Published var resultsText = ""
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    //Since we are going to read video data...
    @Published var output = AVCaptureVideoDataOutput()
    
    //Preview...
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    func Check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                if status {
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func getDevice() -> AVCaptureDevice {
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
            return device
        } else if let device = AVCaptureDevice.default(.builtInTripleCamera, for: .video, position: .back) {
            return device
        } else if let device =  AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            return device
        } else {
            fatalError("Missing expected back camera device!")
        }
    }
    
    func setUp() {
        do {
            self.session.sessionPreset = AVCaptureSession.Preset.hd1280x720
            self.session.beginConfiguration()
            
            let device = getDevice()
            
            let input = try AVCaptureDeviceInput(device: device)
            
            self.output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as AnyHashable as! String: Int(kCVPixelFormatType_32BGRA)]
            self.output.alwaysDiscardsLateVideoFrames = true
            
            let videoOutputQueue = DispatchQueue(label: "VideoQueue")
            self.output.setSampleBufferDelegate(self, queue: videoOutputQueue)
            
            if self.session.canAddInput(input) {
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output) {
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation {
                    self.isTaken.toggle()
                }
            }
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
        
        let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer)
        
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)!
        let byteBuffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        
        for j in 0..<height {
            for i in 0..<width {
                let index = (j * width + i) * 4
                
                let b = byteBuffer[index]
                let g = byteBuffer[index+1]
                let r = byteBuffer[index+2]
                
                if j == 200 && i == 200 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.resultsText = "\(r) \(g) \(b)"
                    }
                    /*if r >= UInt8(110) && g >= UInt8(160) && b >= 20 && b <= UInt8(100) { //Yellow
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.resultsText = "You have COVID-19!"
                        }
                    } else if r >= UInt8(160) && g <= UInt8(80) && b <= UInt8(60) { //Red
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.resultsText = "You do not have COVID-19!"
                        }
                    } else { //Can't find solution
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.resultsText = "Test not found"
                        }
                    }*/
                    byteBuffer[index] = UInt8(0)
                    byteBuffer[index+1] = UInt8(0)
                    byteBuffer[index+2] = UInt8(255)
                }
            }
        }
        
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: CVOptionFlags(0)))
    }
}

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

