//
//  Authority.swift
//  FGrepCTL
//
//  Created by YLCHUN on 2020/11/7.
//

import Foundation

struct AuthorityGrepOption: OptionSet {
    let rawValue: Int64
    static let all: AuthorityGrepOption = [.idfv, .idfa, .mediaLibrary, .bluetooth, .calendar, .capture, .contacts, .location, .motion, .microphone, .notifications, .siri, .speechRecognizer, .photos]

    static let idfv = AuthorityGrepOption(rawValue: 1 << 0)
    static let idfa = AuthorityGrepOption(rawValue: 1 << 1)
    static let mediaLibrary = AuthorityGrepOption(rawValue: 1 << 2)
    static let bluetooth = AuthorityGrepOption(rawValue: 1 << 3)
    static let calendar = AuthorityGrepOption(rawValue: 1 << 4)
    static let capture = AuthorityGrepOption(rawValue: 1 << 5)
    static let contacts = AuthorityGrepOption(rawValue: 1 << 6)
    static let location = AuthorityGrepOption(rawValue: 1 << 7)
    static let motion = AuthorityGrepOption(rawValue: 1 << 8)
    static let microphone = AuthorityGrepOption(rawValue: 1 << 9)
    static let notifications = AuthorityGrepOption(rawValue: 1 << 10)
    static let siri = AuthorityGrepOption(rawValue: 1 << 11)
    static let speechRecognizer = AuthorityGrepOption(rawValue: 1 << 12)
    static let photos = AuthorityGrepOption(rawValue: 1 << 13)

    var value: [String:[String]] {
        var contains = [String:[String]]()
        if self.contains(.idfv) {
            contains["IDFV"] = ["identifierForVendor", "UIDevice"]
        }
        if self.contains(.idfa) {
            contains["IDFA"] = ["advertisingIdentifier", "UIDevice"]
        }
        if self.contains(.mediaLibrary) {
            contains["音乐库"] = ["MPMediaLibrary", "requestAuthorization"]
        }
        if self.contains(.bluetooth) {
            contains["蓝牙 Peripheral"] = ["CBPeripheralManager", "startAdvertising"]
            contains["蓝牙 Central"] = ["CBCentralManager"]
        }
        if self.contains(.calendar) {
            contains["日历"] = ["EKEventStore", "requestAccess"]
        }
        if self.contains(.capture) {
            contains["相机 or 麦克风"] = ["AVCaptureDevice", "requestAccess"]
        }
        if self.contains(.contacts) {
            contains["通讯录"] = ["CNContactStore", "requestAccess"]
        }
        if self.contains(.location) {
            contains["定位 Always"] = ["CLLocationManager", "requestAlwaysAuthorization"]
            contains["定位 InUse"] = ["CLLocationManager", "requestWhenInUseAuthorization"]
        }
        if self.contains(.motion) {
            contains["运动健康"] = ["CMMotionActivityManager", "queryActivityStarting"]
        }
        if self.contains(.microphone) {
            contains["听筒"] = ["AVAudioSession", "requestRecordPermission"]
        }
        if self.contains(.notifications) {
            contains["通知"] = ["UNUserNotificationCenter", "requestAuthorization"]
        }
        if self.contains(.photos) {
            contains["相册"] = ["PHPhotoLibrary", "requestAuthorization"]
        }
        if self.contains(.siri) {
            contains["Siri"] = ["INPreferences", "requestSiriAuthorization"]
        }
        if self.contains(.speechRecognizer) {
            contains["语音识别"] = ["SFSpeechRecognizer", "requestAuthorization"]
        }
        return contains
    }
}


class Authority {
    let grepOption: AuthorityGrepOption
    init(grepOption: AuthorityGrepOption = .all) {
        self.grepOption = grepOption
    }
    
    func grep(atPath: String) -> (originRet: [String: [String]?], authRet: [String: [String]], fileRet:[String: [String]]) {
        let ret = FGrep.grep(contains: self.grepOption.value, atPath: atPath)
        
        var authInfo = [String: [String]]()
        for (name, paths) in ret {
            guard let ps = paths else { continue }
            for p in ps {
                let file = (p as NSString).lastPathComponent
                if authInfo[name] == nil {
                    authInfo[name] = [String]()
                }
                authInfo[name]?.append(file)
            }
        }
        
        var fileInfo = [String: [String]]()
        for (name, paths) in ret {
            guard let ps = paths else { continue }
            for p in ps {
                let key = (p as NSString).lastPathComponent
                if fileInfo[key] == nil {
                    fileInfo[key] = [String]()
                }
                fileInfo[key]?.append(name)
            }
        }
        return (ret, authInfo, fileInfo)
    }
    
    func authority(path: String) {
        let ret = FGrep.grep(contains: AuthorityGrepOption.all.value, atPath: path)
        
        var authorityInfo = [String: [String]]()
        for (name, paths) in ret {
            guard let ps = paths else { continue }
            for p in ps {
                let file = (p as NSString).lastPathComponent
                if authorityInfo[name] == nil {
                    authorityInfo[name] = [String]()
                }
                authorityInfo[name]?.append(file)
            }
        }
        
        var fileInfo = [String: [String]]()
        for (name, paths) in ret {
            guard let ps = paths else { continue }
            for p in ps {
                let key = (p as NSString).lastPathComponent
                if fileInfo[key] == nil {
                    fileInfo[key] = [String]()
                }
                fileInfo[key]?.append(name)
            }
        }
    }
}

extension Dictionary {
    @discardableResult
    func write(toFile: String, atomically: Bool)->Bool {
        return NSDictionary(dictionary: self as [AnyHashable : Any]).write(toFile: toFile, atomically: atomically)
    }
}
