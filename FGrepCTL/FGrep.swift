//
//  Grep.swift
//  AuthorityCTL
//
//  Created by YLCHUN on 2020/11/6.
//

import Foundation

//contains ["别名" : ["匹配关键字", "在之前基础上再次匹配关键字", ...]]
class FGrep {
    private let grap: Grep
    init(grepPath: String = "/usr/bin/grep") {
        grap = Grep(grepPath: grepPath)
    }
    
    /// 并发执行grep（进程并发）
    /// - Parameters:
    ///   - grepPath: def /usr/bin/grep
    ///   - concurrentCount: 并发量
    ///   - contains: grep关键字字典
    ///   - atPath: grep目标路径
    /// - Returns: grep结果
    static func grep(grepPath: String = "/usr/bin/grep", concurrentCount: Int = 0, contains:[String:[String]], atPath:String) -> [String:[String]?] {
        var ret = [String:[String]?]()
        let beginTime = Date()
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = concurrentCount > 0 ? concurrentCount : contains.count
        var idxbegin = 0
        var idxend = 0
        let lock = NSLock()
        for (n, cs) in contains {
            queue.addOperation {
                lock.lock()
                idxbegin += 1
                print("===\(contains.count):\(idxbegin)===>> \(n)")
                lock.unlock()
                let r = FGrep(grepPath:grepPath).grep(contains: cs, atPath: atPath);
                lock.lock()
                ret[n] = r
                idxend += 1
                print("<<===\(contains.count):\(idxend)=== \(n)")
                lock.unlock()
            }
        }
        queue.waitUntilAllOperationsAreFinished()
        let usedTime = Date().timeIntervalSince(beginTime)
        print("used time: \(usedTime)s")
        return ret
    }
    
    func grep(contains:[String:[String]], atPath:String) -> [String:[String]?] {
        var ret = [String:[String]?]()
        let beginTime = Date()
        var idx = 0
        for (n, cs) in contains {
            idx += 1
            print("===\(contains.count):\(idx)===>> \(n)")
            ret[n] = grep(contains: cs, atPath: atPath);
            print("")
        }
        let usedTime = Date().timeIntervalSince(beginTime)
        print("used time: \(usedTime)s")
        return ret
    }
    
    func grep(contains:[String], atPath:String) -> [String] {
        var paths = [atPath]
        for c in contains {
            let rets = grep(contains: c, atPaths: paths)
            paths = []
            for ret in rets {
                let lines = ret.components(separatedBy:"\n")
                for line in lines {
                    if line.count == 0 || line.contains("/DerivedData/") { continue }
                    let exten = (line as NSString).pathExtension
                    if !["m", "mm", "c", "cpp", "", "a"].contains(exten) { continue }
                    if let p = matcheRegex(string: line, regex: "(?=\\/).*(?<=\\.(framework|a))").first {
                        if !paths.contains(p) {
                            paths.append(p)
                        }
                    }
                    else if line.contains("/Pods/") {
                        if let p = matcheRegex(string: line, regex: "(?=\\/).*\\/Pods\\/[a-zA-Z_+\\s]+(?=\\/)").first {
                            if !paths.contains(p) {
                                paths.append(p)
                            }
                        }
                    }
                    else {
                        if !paths.contains(line) {
                            paths.append(line)
                        }
                    }
                }
            }
        }
        return paths
    }
    
    
    func grep(contains:String, atPaths:[String]) -> [String] {
        var rets = [String]()
        for atPath in atPaths {
            let ret = self.grap.grep(contains: contains, atPath: atPath).log ?? ""
            rets.append(ret);
        }
        return rets
    }
    
    private func matcheRegex(string:String, regex:String)->[String] {
        var arr = [String]()
        if let regularExpression = try? NSRegularExpression(pattern: regex, options: .caseInsensitive) {
            let matches = regularExpression.matches(in: string, options: [], range: NSRange(location: 0, length: string.count))
            for matche in matches {
                let str = (string as NSString).substring(with: matche.range)
                arr.append(str)
            }
        }
        return arr
    }
}

fileprivate class Grep {
    let grep: Execution
    let arg = "-rls"
    init(grepPath: String) {
        grep = Execution(path: grepPath)
    }
    
    func grep(contains:String, atPath:String) -> (ret: Int, log: String?) {
        return grep.execute(arguments: [arg, contains, atPath])
    }
}

