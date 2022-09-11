import Foundation
import SwiftUI
import TensorFlowLiteTaskVision

struct MainScreenView: View{
    @EnvironmentObject private var deviceManager :DeviceManager
    
    @State var showingImagePicker = false
    @State var showingCameraPicker = false
    @State var showingDeviceScreenView = false
    
    @State var pickedImage: UIImage?
    @State var detectionResult: DetectionResult?
    
    var body:some View{
        NavigationView{
            VStack(alignment: .center) {
                ZStack{
                    if let image = pickedImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .background(Color.white)
                            .frame(maxHeight: .infinity)
                    }else{
                        VStack{
                            Spacer()
                            Text("シールプログラミングへようこそ")
                            Spacer()
                        }.background(Color.white)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    }
                    if let detectionResult = detectionResult {
                        DetectionResultView(detections: detectionResult.detections, imageSize: pickedImage!.size)
                    }
                }.aspectRatio(3/4, contentMode: ContentMode.fit)
                    .background(Color.white)
                Spacer()
                HStack(alignment: .center){
                    Spacer()
                    CircleButton(
                        image: Image(systemName: "camera.fill"),
                        label: "とる",
                        color: Color("PrimaryColor"),
                        action: {
                            // showingCameraPicker.toggle()
                            showingImagePicker.toggle()
                        }
                    )
                    Spacer()
                    CircleButton(
                        image: Image("BluetoothIconDefault"),
                        label: "つなぐ",
                        color: Color("PrimaryColor"),
                        action: {
                            showingDeviceScreenView = true
                        }
                    )
                    Spacer()
                    CircleButton(
                        image:Image(systemName: "car.fill"),
                        label: "おくる",
                        color: Color("SecondaryColor"),
                        action: {
                            // TODO : プログラムをおくる
                        }
                    )
                    Spacer()
                }
            }.sheet(isPresented:$showingImagePicker) {
                ImagePickerView(image: $pickedImage, sourceType: .library)
            }.sheet(isPresented:$showingCameraPicker) {
                ImagePickerView(image: $pickedImage, sourceType: .camera)
            }.sheet(isPresented: $showingDeviceScreenView) {
                DeviceScanView(onConnect: {
                    showingDeviceScreenView = false
                }).environmentObject(deviceManager)
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                .background(Color("ControlBackgroundColor"))
                .navigationBarTitle("シールプログラミング")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
