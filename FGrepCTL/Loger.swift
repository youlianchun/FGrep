//
//  Log.swift
//  FGrepCTL
//
//  Created by YLCHUN on 2020/11/7.
//

import Foundation

class Loger {
    fileprivate static let `default` = Loger()
    private init() {}
    private let lock = NSLock()
    private var isRelog :Bool = false
    
    fileprivate func log(_ string: String){
        lock.lock()
        if isRelog {
            print("\u{1B}[1A\u{1B}[K\(string)")//当前光标位置
//            print("\u{1B}8")//恢复光标状态和位置
            isRelog = false
        }
        else {
            print(string)
        }
        lock.unlock()
    }
    
    fileprivate func relog(_ string:String) {
        lock.lock()
        if !isRelog {
//            print("\u{1B}7")//保存光标状态和位置
            isRelog = true
            print("\(string)")
        }else {
            print("\u{1B}[1A\u{1B}[K\(string)")//当前光标位置
        }
        lock.unlock()
    }
    
    static func log(_ string: String) {
        Loger.default.log(string)
    }

    static func relog(_ string:String) {
        Loger.default.relog(string)
    }
}

func cyclelog(_ logs: [String], _ timeInterval: TimeInterval,  handler: @escaping(_ stop: inout Bool, _ needLog: inout Bool)->Void){
    DispatchQueue(label: "com.cyclelog.thread").async {
        let runloop = RunLoop.current
        runloop.add(Port(), forMode: .default)
        var index = 0
        let timer = Timer(timeInterval: timeInterval, repeats: true) { (timer) in
            var stop = false
            var needLog = true
            handler(&stop, &needLog)
            if stop {
                timer.invalidate()
            }
            if needLog {
                let idx = index % logs.count
                index += 1
                Loger.relog(logs[idx])
            }
        }
        runloop.add(timer, forMode: .common)
        runloop.run()
    }
}
