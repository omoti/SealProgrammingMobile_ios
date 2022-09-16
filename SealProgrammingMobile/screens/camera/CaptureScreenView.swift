import SwiftUI
import Foundation
import TensorFlowLiteTaskVision

struct CaptureScreenView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var camera = CamearaManager() // 再描画しても状態を保持
    @EnvironmentObject private var sealDetector :SealDetector
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                CloseButton(action: {
                    camera.stop()
                    dismiss()
                })
            }.padding(10)
            ZStack{
                PreviewView(camera: camera, aspectRatio: 3/4)
                
                // 撮影画像
                if let image = camera.capturedUiImage {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: .infinity)
                    
                    // 検出結果を重ねる
                    if sealDetector.detections != nil {
                        DetectionResultView(detections: sealDetector.detections!, imageSize: camera.capturedUiImage!.size)
                    }
                }
            }.onAppear(){
                camera.setupCaptureSession()
            }.aspectRatio(3/4, contentMode: ContentMode.fit)
            Spacer()
            if(camera.captured){
                HStack{
                    Spacer()
                    IconButton(
                        image: Image(systemName: "list.bullet"),
                        label: "リスト",
                        action: {
                            // 一覧表示
                        }
                    )
                    Spacer()
                    CircleButton(
                        image: Image(systemName: "checkmark"),
                        label: "OK",
                        color: Color("PrimaryColor"),
                        action: {
                            sealDetector.detect(image: camera.capturedUiImage!)
                        }
                    )
                    Spacer()
                    IconButton(
                        image: Image(systemName: "camera"),
                        label: "とりなおす",
                        action: {
                            camera.restart()
                        }
                    )
                    Spacer()
                }.padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
            }else{
                HStack{
                    Spacer()
                    ShutterButton(action: {
                        camera.capture()
                    })
                    Spacer().overlay(
                        SwitchCameraButton(action: {
                            camera.switchPosition()
                        })
                    )
                }.padding(20)
            }
        }.background(.black)
    }
}
