//
//  main.swift
//  FGrepCTL
//
//  Created by YLCHUN on 2020/11/6.
//

import Foundation

print("Hello, FGrep!")

if CommandLine.argc == 1 {
    print("FGrep /xxx/xxx")
}
else {
    let path = CommandLine.arguments[1]
    authority(path:path)
}


func authority(path: String) {
    let ret =  Authority(grepOption: .all).grep(atPath: path);
    let oPath = (path as NSString).deletingLastPathComponent
    print("output path: \(oPath)")
    ret.originRet.write(toFile: "\(path)_authority_origin.plist", atomically: true)
    ret.authRet.write(toFile: "\(path)_authority_auth.plist", atomically: true)
    ret.fileRet.write(toFile: "\(path)_authority_file.plist", atomically: true)
}
