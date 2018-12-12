//
//  UserData.swift
//  FACS-Recorder
//
//  Created by 권영진 on 14/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class UserData {
    
    var fileName = String()
    var fileNameDict = [NameCase:String]()
    var recentListDict = [NameCase:[String]]()
    var hasRecentDict = [NameCase:Bool]()
    
    init() {
        fileName = ""
        for key in NameCase.allCases {
            fileNameDict[key] = ""
            recentListDict[key] = []
            hasRecentDict[key] = false
        }
    }
            
    func set(key:NameCase,val:String){
        // check if the given key is valid
        if fileNameDict.keys.contains(key){
            fileNameDict[key] = val
        }
    }
            
    func setRecent(key: NameCase,recentList:[String]){
        if recentListDict.keys.contains(key){
            recentListDict[key] = recentList
            if (recentListDict[key]!.count > 9){
                recentListDict[key]?.removeFirst()
            }
            hasRecentDict[key] = true
        }
    }
    
    func appendRecent(key: NameCase, item: String){
        if recentListDict.keys.contains(key){
            
            if recentListDict[key] != nil {
                // append it as the last index
                recentListDict[key]?.append(item)
                // remove if there's a duplicated value exists in the earlier indices
                while ((recentListDict[key]?.filter{$0 == item}.count)! > 1 ) {
                    if let atThisIndex = recentListDict[key]!.firstIndex(of: item) {
                        //print(" firstIndex: \(atThisIndex)")
                        recentListDict[key]!.remove(at: atThisIndex)
                    }
                }
                // Keep the array size to under 10
                while (recentListDict[key]!.count > 9) {
                    recentListDict[key]?.removeFirst()
                }
            }
        }
    }
    
    func recordRecentNames(){
        for key in NameCase.allCases{
            if fileNameDict[key] != ""{
                appendRecent(key: key, item: fileNameDict[key]!)
            }
        }
    }
    
    func isNameReady() -> Bool{
        var nameSplits: [String] = []
        for key in NameCase.allCases{
            if (fileNameDict[key] != ""){
                nameSplits.append(fileNameDict[key]!)
            }
        }
        if (nameSplits.count > 4){
            for (i,split) in nameSplits.enumerated(){
                if (i == 0){
                    fileName = split
                }else{
                    fileName += "_"+split
                }
            }
            return true
        }
        return false
    }
}
