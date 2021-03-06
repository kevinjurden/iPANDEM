//
//  ResultsView.swift
//  Camera view for image processing of a SalivaMAX test strip(s)
//
//  Created by Kevin Jurden on 3/15/21.
//

import SwiftUI
import AVFoundation
//import GPUImage



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
                ZStack {
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
                }
                Spacer()
                Text("\(camera.resultsText[0])")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text("\(camera.resultsText[1])")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text("\(camera.resultsText[2])")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text("\(camera.resultsText[3])")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text("\(camera.resultsText[4])")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                Text("\(camera.resultsText[5])")
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

    @Published var resultsText : [String] = ["num0", "num1", "num2", "num3", "num4", "num5"]
    
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
            self.session.sessionPreset = AVCaptureSession.Preset.cif352x288
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
        
        let width = CVPixelBufferGetWidth(imageBuffer) //let width = CVPixelBufferGetWidth(imageBuffer)
        let height = CVPixelBufferGetHeight(imageBuffer) //let height = CVPixelBufferGetHeight(imageBuffer)
        
        let baseAddress = CVPixelBufferGetBaseAddress(imageBuffer)!
        let byteBuffer = baseAddress.assumingMemoryBound(to: UInt8.self)
        
        struct Screen{
            var Sheight: Double!
            var Swidth: Double!
        }
        struct ScreenInt{
            var Sheight: Int!
            var Swidth: Int!
        }
        
        //iphone Screen values
        let screensize = UIScreen.main.bounds
        let iphone11 = Screen(Sheight: Double(screensize.width), Swidth: Double(screensize.height))
        
        /*let perccoord1 = Screen(Sheight: 0.5465, Swidth: 0.3191)
        let perccoord2 = Screen(Sheight: 0.5465, Swidth: 0.4255)
        let perccoord3 = Screen(Sheight: 0.5465, Swidth: 0.5319)
        let perccoord4 = Screen(Sheight: 0.4535, Swidth: 0.3191)
        let perccoord5 = Screen(Sheight: 0.4535, Swidth: 0.4255)
        let perccoord6 = Screen(Sheight: 0.4535, Swidth: 0.5319)*/
        
        let perccoord1 = Screen(Sheight: 0.60456, Swidth: 0.3191)
        let perccoord2 = Screen(Sheight: 0.60456, Swidth: 0.4255)
        let perccoord3 = Screen(Sheight: 0.60456, Swidth: 0.5319)
        let perccoord4 = Screen(Sheight: 0.39535, Swidth: 0.3191)
        let perccoord5 = Screen(Sheight: 0.39535, Swidth: 0.4255)
        let perccoord6 = Screen(Sheight: 0.39535, Swidth: 0.5319)
        
        //Screen & itself
        let Camera = Screen(Sheight: Double(height), Swidth: Double(width))
        //values desired to be place into array
        let LUT1 = coordreturn(Displayin: iphone11, Camerain: Camera, Percentin: perccoord1)
        let LUT2 = coordreturn(Displayin: iphone11, Camerain: Camera, Percentin: perccoord2)
        let LUT3 = coordreturn(Displayin: iphone11, Camerain: Camera, Percentin: perccoord3)
        let LUT4 = coordreturn(Displayin: iphone11, Camerain: Camera, Percentin: perccoord4)
        let LUT5 = coordreturn(Displayin: iphone11, Camerain: Camera, Percentin: perccoord5)
        let LUT6 = coordreturn(Displayin: iphone11, Camerain: Camera, Percentin: perccoord6)
        
        //coord values
        func coordreturn(Displayin: Screen, Camerain: Screen, Percentin: Screen) -> ScreenInt {
            //Author: Hector Figueroa
            //Input: Displayin, Camerain, Percentin
            //Output: LUTin
            //Date: 05/07/2021
            //Known Issues: screen must be as tall or taller than camera, not wider
            
            //values for ratio correction
            let ratiocamera = (Displayin.Sheight/Displayin.Swidth)
            let xoffset = (Camerain.Sheight - (Camerain.Swidth*ratiocamera))/2
            
            //LUT values
            //let LUTWidth = Int(((Camerain.Swidth - (2*xoffset)) * Percentin.Swidth)) + Int(xoffset)
            let LUTWidth = Int(((Camerain.Swidth) * Percentin.Swidth))
            //let LUTHeight = Int(Camerain.Sheight * Percentin.Sheight)
            let LUTHeight = Int(((Camerain.Sheight - (2*xoffset)) * Percentin.Sheight)) + Int(xoffset)
            
            let returnvalue = ScreenInt(Sheight: LUTHeight, Swidth: LUTWidth)
            
            return returnvalue
        }
        
        let LUTnum : [ScreenInt] = [LUT1, LUT2, LUT3, LUT4, LUT5, LUT6]
        
        for LUTint in 0..<6 {
            for j in 0..<height {
                for i in 0..<width {
                    let index = (j * width + i) * 4
                    
                    let b = byteBuffer[index]
                    let g = byteBuffer[index+1]
                    let r = byteBuffer[index+2]
                    
                    if j == LUTnum[LUTint].Sheight && i == LUTnum[LUTint].Swidth {
                        if r >= UInt8(110) && g >= UInt8(160) && b >= UInt8(20) && b <= UInt8(190) { //Yellow
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.resultsText[LUTint] = "You have COVID-19!"
                            }
                        } else if r >= UInt8(160) && g <= UInt8(50) && b <= UInt8(80) { //Red
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.resultsText[LUTint] = "You do not have COVID-19!"
                            }
                        } else { //Can't find solution
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.resultsText[LUTint] = "Test not found"
                            }
                        }
                        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.resultsText[LUTint] = "\(r) \(g) \(b) \(height) \(width) \(j) \(i)"
                        }*/
                        //byteBuffer[index] = UInt8(255)
                        //byteBuffer[index+1] = UInt8(0)
                        //byteBuffer[index+2] = UInt8(0)
                    }
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

