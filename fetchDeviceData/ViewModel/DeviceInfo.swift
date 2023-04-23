//
//  DeviceInfo.swift
//  fetchDeviceData
//
//  Created by RUMEN GUIN on 23/04/23.
//
//IMEI stands for "International Mobile Equipment Identity". It is a unique identifier for mobile devices that is used to identify and track devices on a cellular network.
import UIKit
import AVFoundation
import Metal

final class DeviceInfo: ObservableObject{
    static let shared = DeviceInfo()
    
    // MARK: - Battery Specs
    @Published var batteryLevel: Int = 0
    @Published var batteryStateDescription: String = ""
    
    //MARK: - CPU and GPU Specs
    @Published var cpu: String = ""
    @Published var cpuCore: String = ""
    @Published var gpu: String = ""
    
    init() {
        UIDevice.current.isBatteryMonitoringEnabled = true //to monitor the battery level
        self.batteryLevel = Int(UIDevice.current.batteryLevel * 100)
        setBatteryState()
        self.cpu = getCPUInfo()
        self.cpuCore = getCPUCore()
        self.gpu = getGPUInfo() ?? ""
    }
    
    //MARK: - Device Info
    let deviceName = UIDevice.current.name
    let systemName = UIDevice.current.systemName
    let systemVersion = UIDevice.current.systemVersion
    let IMEI = UIDevice.current.identifierForVendor?.uuidString
    
    //MARK: - Storage Info
    let totalDiskSpace = UIDevice.current.totalDiskSpaceInGB
    let freeDiskSpace = UIDevice.current.freeDiskSpaceInGB
    let userDiskSpace = UIDevice.current.usedDiskSpaceInGB
    
}


//MARK: - Storage
public extension UIDevice {
    func MBFormatter(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = ByteCountFormatter.Units.useMB
        formatter.countStyle = ByteCountFormatter.CountStyle.decimal
        formatter.includesUnit = false
        return formatter.string(fromByteCount: bytes) as String
    }
    
    //MARK: Get String Value
    var totalDiskSpaceInGB:String {
       return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var freeDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var usedDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    var totalDiskSpaceInMB:String {
        return MBFormatter(totalDiskSpaceInBytes)
    }
    
    var freeDiskSpaceInMB:String {
        return MBFormatter(freeDiskSpaceInBytes)
    }
    
    var usedDiskSpaceInMB:String {
        return MBFormatter(usedDiskSpaceInBytes)
    }
    
    //MARK: Get raw value
    var totalDiskSpaceInBytes:Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
    
    /*
     Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
     Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
     This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
     */
    var freeDiskSpaceInBytes:Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space //
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
            let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }
    
    var usedDiskSpaceInBytes:Int64 {
       return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }

}

//MARK: - CPU Specs
extension DeviceInfo {
    private func getCPUInfo() -> String {
        var size: size_t = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0, count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return "\(machine.withUnsafeBytes { String(cString: $0.baseAddress!.assumingMemoryBound(to: CChar.self)) })"
    }
    
    private func getCPUCore() -> String {
        var cpu: Int32 = 0
        var cpusize: size_t = MemoryLayout<Int32>.stride
        sysctlbyname("hw.ncpu", &cpu, &cpusize, nil, 0)
        return "\(cpu)"
    }
}

//MARK: - GPU Specs
extension DeviceInfo {

    func getGPUInfo() -> String? {
        guard let device = MTLCreateSystemDefaultDevice() else {
            return nil
        }
        let name = device.name
        return name
    }
}

//MARK: - Battery Specs
extension DeviceInfo {
    private func setBatteryState() {
        let batteryState = UIDevice.current.batteryState
        self.batteryStateDescription = getBatteryDescription(for: batteryState)
    }
    
    private func getBatteryDescription(for state: UIDevice.BatteryState) -> String {
        switch state {
        case .unknown:
            return "Unknown"
        case .unplugged:
            return "On battery power"
        case .charging:
            return "Charging"
        case .full:
            return "Full Charge"
        @unknown default:
            return "Unknown"
        }
    }
}


