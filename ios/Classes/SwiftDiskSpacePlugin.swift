import Flutter
import UIKit

public class SwiftDiskSpacePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "disk_space", binaryMessenger: registrar.messenger())
        let instance = SwiftDiskSpacePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getFreeDiskSpace":
            result(UIDevice.current.freeDiskSpaceInGB)
        case "getTotalDiskSpace":
            result(UIDevice.current.totalDiskSpaceInGB)
        case "getUsedDiskSpace":
             result(UIDevice.current.usedDiskSpaceInGB)
        case "getPercentageUsedDiskSpace":
             result(UIDevice.current.percentageUsed)
        case "getFreeDiskSpaceForPath":
            result(UIDevice.current.freeDiskSpaceForPathInMB(path: (call.arguments as? [String: String])!["path"]!))
        default:
            result(0.0)
        }
        result("iOS " + UIDevice.current.systemVersion)
        
    }
}

extension UIDevice {
    var totalDiskSpaceInGB:String {
        return String(format: "%0.0f GB", convertToFloat(convert(totalDiskSpaceInBytes)))
    }
    
    var freeDiskSpaceInGB:String {
        return String(format: "%0.0f GB", convertToFloat(convert(freeDiskSpaceInBytes)))
    }
    
    var usedDiskSpaceInGB:String {
        return String(format: "%0.0f GB", convertToFloat(convert(usedDiskSpaceInBytes)))
    }

    var percentageUsed:String {
        let roundedPercentage = Double(usedDiskSpaceInBytes) / Double(totalDiskSpaceInBytes)
        let formattedPercentage = String(format: "%.0f", roundedPercentage * 100)
        return formattedPercentage
    }
    
    public func freeDiskSpaceForPathInMB(path: String) -> String {
//         return Double(freeDiskSpaceForPathInBytes(path: path) / (1024 * 1024))
        return ""
    }
    
    
    
    //MARK: Get raw value
    var totalDiskSpaceInBytes:Int64 {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
            if let freeSize = dictionary[FileAttributeKey.systemSize] as? NSNumber {
                return freeSize.int64Value
            }
        }else{
            print("Error Obtaining System Memory Info:")
        }
        return 0
    }
    
    /*
     Total available capacity in bytes for "Important" resources, including space expected to be cleared by purging non-essential and cached resources. "Important" means something that the user or application clearly expects to be present on the local system, but is ultimately replaceable. This would include items that the user has explicitly requested via the UI, and resources that an application requires in order to provide functionality.
     Examples: A video that the user has explicitly requested to watch but has not yet finished watching or an audio file that the user has requested to download.
     This value should not be used in determining if there is room for an irreplaceable resource. In the case of irreplaceable resources, always attempt to save the resource regardless of available capacity and handle failure as gracefully as possible.
     */
    var freeDiskSpaceInBytes:Int64 {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        if let dictionary = try? FileManager.default.attributesOfFileSystem(forPath: paths.last!) {
            if let freeSize = dictionary[FileAttributeKey.systemFreeSize] as? NSNumber {
                return freeSize.int64Value
            }
        }else{
            print("Error Obtaining System Memory Info:")
        }
        return 0
    }
    
    var usedDiskSpaceInBytes:Int64 {
        return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }
    
    public func freeDiskSpaceForPathInBytes(path: String) -> Int64 {
//        if #available(iOS 11.0, *) {
//            if let space = try? URL(fileURLWithPath: path).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
//                return space ?? 0
//            } else {
//                return 0
//            }
//        } else {
//            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: path),
//               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
//                return freeSpace
//            } else {
//                return 0
//            }
//        }
        return 0
    }
    
    private func convert(_ bytes: Int64?, to units: ByteCountFormatter.Units = .useGB) -> String {
        if let bytes = bytes, bytes > 0 {
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = units
            formatter.countStyle = ByteCountFormatter.CountStyle.decimal
            formatter.includesUnit = false
            return formatter.string(fromByteCount: bytes)
        } else {
            return "0"
        }
    }

    private func convertToFloat(_ inputString: String) -> Float {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let number = numberFormatter.number(from: inputString) {
            return number.floatValue
        } else {
            return 0
        }
    }
    
}
