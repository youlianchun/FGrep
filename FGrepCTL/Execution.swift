//
//  Execution.swift
//  AuthorityCTL
//
//  Created by YLCHUN on 2020/11/6.
//

import Foundation

class Execution {
    let launchPath : String
    init(path:String) {
        launchPath = path
    }
    
    func execute(arguments: [String]? = nil) -> (ret: Int, log: String?) {
//        let arg = arguments?.joined(separator: " ") ?? ""
//        print("command: \(launchPath) \(arg)")

        let task = Process()
        let pipe = Pipe()
        task.launchPath = launchPath
        task.standardOutput = pipe
        task.arguments = arguments
        
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let log = String(data: data, encoding: .utf8)
        let ret = Int(task.terminationStatus)
        return (ret, log)
    }
}
