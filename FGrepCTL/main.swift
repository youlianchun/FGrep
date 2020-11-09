//
//  main.swift
//  FGrepCTL
//
//  Created by YLCHUN on 2020/11/6.
//

import Foundation

let path = CommandLine.arguments[0]
let name = (path as NSString).lastPathComponent

print("\nHello, \(name)!\n")

if CommandLine.argc == 1 {
    print("\(name) /xxx/xxx")
}
else {
    let path = CommandLine.arguments[1]
    authority(path:path)
}


func authority(path: String) {
    let ret =  Authority(grepOption: .all).grep(atPath: path);
    print("output path: \(path)_\(name)_xxx.plist")
    ret.originRet.write(toFile: "\(path)_\(name)_origin.plist", atomically: true)
    ret.authRet.write(toFile: "\(path)_\(name)_auth.plist", atomically: true)
    ret.fileRet.write(toFile: "\(path)_\(name)_file.plist", atomically: true)
}
