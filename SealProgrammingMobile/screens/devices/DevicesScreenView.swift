import SwiftUI

struct DeviceScanView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var deviceModel :DeviceModel
    
    var onConnect: () -> Void
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center){
                List(){
                    if let connectedDevice = deviceModel.connectedPeripheral {
                        ConnectedDeviceItem(name: connectedDevice.name, action: {
                            deviceModel.disconnect()
                        })
                    }
                    ForEach(deviceModel.foundPeripherals, id: \.self) { peripheral in
                        FoundDeviceItem(
                            name:peripheral.name,
                            action: {
                                deviceModel.connect(peripheral: peripheral)
                                onConnect()
                            }
                        )
                    }
                    HStack(alignment: .center){
                        Spacer()
                        ProgressView("")
                        Spacer()
                    }.padding(10)
                }
            }.onAppear(){
                deviceModel.startScan()
            }.onDisappear(){
                deviceModel.stopScan()
            }.navigationBarTitle("つなぐ")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: CloseButton(action: {
                    close()
                }))
        }
    }
    
    func close(){
        dismiss()
    }
}
