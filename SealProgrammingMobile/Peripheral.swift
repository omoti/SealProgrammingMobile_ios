import Foundation
import CoreBluetooth

struct Peripheral: Hashable{
    var name: String = ""
    var rssi: Int = 0
    var uuid: String = ""
    var peripheral: CBPeripheral
}
