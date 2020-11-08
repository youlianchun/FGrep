//
//  Log.swift
//  FGrepCTL
//
//  Created by YLCHUN on 2020/11/7.
//

import Foundation

func log(_ string: String) {
    loger.log(string)
}

func relog(_ string:String) {
    loger.relog(string)
}

fileprivate let loger = Loger()

fileprivate class Loger {
    let lock = NSLock()
    var isRelog :Bool = false
    func log(_ string: String){
        lock.lock()
        if isRelog {
            print("\u{1B}[1A\u{1B}[K\(string)")//当前光标位置
            print("\u{1B}8")//恢复光标状态和位置
            isRelog = false
        }
        else {
            print(string)
        }
        lock.unlock()
    }
    
    func relog(_ string:String) {
        lock.lock()
        if !isRelog {
            print("\u{1B}7")//保存光标状态和位置
            isRelog = true
        }
        print("\u{1B}[1A\u{1B}[K\(string)")//当前光标位置
        lock.unlock()
    }
}

