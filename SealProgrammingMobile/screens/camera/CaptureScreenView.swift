import SwiftUI
import Foundation

struct CaptureScreenView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var deviceManager :DeviceManager
    @StateObject private var camera = CamearaManager() // 再描画しても状態を保持
    
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
            }.onAppear(){
                camera.setupCaptureSession()
            }.aspectRatio(3/4, contentMode: ContentMode.fit)
            Spacer()
            if(camera.captured){
                HStack{
                    Spacer()
                    SwitchCameraButton(action: {
                        camera.restart()
                    })
                    Spacer()
                }.padding(20)
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
