//
//  DeviceInfo.swift
//  TennisBusiness
//
//  Created by Nikolay Mikhailishin on 6/5/19.
//  Copyright © 2019 nikolay.mihailishin. All rights reserved.
//

import UIKit

/// Bridge for UIDevice/UIScreen functionality
final class DeviceInfo {
    // MARK: - Properties
    // MARK: - Screen properties
    
    static var screenScale: CGFloat {
        return UIScreen.main.scale
    }
    
    static var screenSize: CGSize {
        return UIScreen.main.bounds.size
    }
    
    
    
    // MARK: - Device properties
    
    static var deviceId: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    static var deviceName: String? {
        return UIDevice.current.name
    }
    
    static var userInterfaceIdiom: UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
    
    static var isTablet: Bool {
        return userInterfaceIdiom == .pad
    }
    
    static var isPhone: Bool {
        return userInterfaceIdiom == .phone
    }
    
    static var isiPhoneXOrBigger: Bool {
        guard isPhone else { return false }
        return DeviceInfo.screenSize.height >= 812.0
    }
    
    static var isTV: Bool {
        return userInterfaceIdiom == .tv
    }
    
    static var isSmallPhone: Bool {
        return DeviceInfo.screenSize.width <= 320
    }
    
    static var rawDeviceVersion: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { (identifier, element) in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    static var deviceVersion: String {
        switch rawDeviceVersion {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "iPad7,1", "iPad7,2", "iPad7,3", "iPad7,4":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return rawDeviceVersion
        }
    }
    
    static var deviceLanguageIdentifier: String? {
        return Locale.preferredLanguages.first
    }
    
    /// Full RAM size in bytes
    static var fullRAMSize: UInt64 {
        return ProcessInfo.processInfo.physicalMemory
    }
    
    /// Free RAM size in bytes
    static var freeRAMSize: UInt64 {
        var pageSize: vm_size_t = 0
        host_page_size(mach_host_self(), &pageSize)
        var vmStat = vm_statistics()
        var count = UInt32(MemoryLayout<vm_statistics>.size / MemoryLayout<integer_t>.size)
        let result = UnsafeMutablePointer(&vmStat).withMemoryRebound(to: integer_t.self, capacity: 1) { (stat) -> kern_return_t in
            host_statistics(mach_host_self(), HOST_VM_INFO, stat, &count)
        }
        guard result == KERN_SUCCESS else {
            return 0
        }
        let free = UInt64(vmStat.free_count) * UInt64(pageSize)
        return free
    }
    
    /// Used RAM size in bytes
    static var usedRAMSize: UInt64 {
        return fullRAMSize - freeRAMSize
    }
    
    #if os(iOS)
    static var orientation: UIInterfaceOrientation {
        // Check if orientation can be defined from device orientation.
        // Because status bar orientation can be controlled by every view controller.
        let deviceOrientation = UIDevice.current.orientation
        switch deviceOrientation {
        case .unknown, .faceUp, .faceDown:
            return interfaceOrientation
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        case .landscapeRight:
            return .landscapeRight
        default:
            return .unknown
        }
    }
    
    static var interfaceOrientation: UIInterfaceOrientation {
        return UIApplication.shared.statusBarOrientation
    }
    #endif
    
    
    
    // MARK: - OS properties
    
    static var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    static var osName: String {
        return UIDevice.current.systemName
    }
    
    static var fullOSVersion: String {
        return "\(osName) \(osVersion)"
    }
    
    
    
    // MARK: - Client properties
    
    static var versionNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
    }
    
    static var buildNumber: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
    
    static var clientVersionForDebug: String {
        return "\(versionNumber) (\(buildNumber))"
    }
    
    static var clientVersion: String {
        return "\(versionNumber).\(buildNumber)"
    }
    
    
    
    // MARK: - Public
    
    /// Returns OS version number in the format "X.X.X.X" with given number of components
    static func extendedOSVersion(componentsCount: Int) -> String {
        let defaultOSVersion = UIDevice.current.systemVersion
        let defaultComponents = defaultOSVersion.components(separatedBy: ".")
        var components: [String] = []
        for index in 0..<componentsCount {
            guard index < defaultComponents.count else {
                components.append("0")
                continue
            }
            let component = defaultComponents[index]
            components.append(component)
        }
        let result = components.joined(separator: ".")
        return result
    }
}
