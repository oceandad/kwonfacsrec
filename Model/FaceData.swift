//
//  FaceData.swift
//  FACS-Recorder
//
//  Created by 권영진 on 13/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import ARKit

class FaceData{
    var blendShape: [ARFaceAnchor.BlendShapeLocation:NSNumber]
    var headMatrix: simd_float4x4
    var leftEyeMatrix:simd_float4x4
    var rightEyeMatrix:simd_float4x4
    var timestamp: Double
    
    init(bsDict: [ARFaceAnchor.BlendShapeLocation:NSNumber],headMat:simd_float4x4,leftEyeMat:simd_float4x4,rightEyeMat:simd_float4x4,time: Double) {
        blendShape = bsDict
        headMatrix = headMat
        leftEyeMatrix = leftEyeMat
        rightEyeMatrix = rightEyeMat
        timestamp = time
    }
    
    func initialize(bsDict: [ARFaceAnchor.BlendShapeLocation:NSNumber],headMat:simd_float4x4,leftEyeMat:simd_float4x4,rightEyeMat:simd_float4x4,time: Double) {
        blendShape = bsDict
        headMatrix = headMat
        leftEyeMatrix = leftEyeMat
        rightEyeMatrix = rightEyeMat
        timestamp = time
    }
}

enum TrackNode {
    case head,lefteye,righteye
}

class FaceDataBank{
    var elems: [FaceData]
    var startTime: Double = 0.0
    var frameInterval: Double = 0.016666
    var frameRate: Double = 60.0
    
    init() {
        elems = []
    }
    func clear(){
        elems.removeAll()
    }

    func normalizeTimestamps() {
        // Round up to miliseconds
        if elems.count > 1 {

            // Remove the frozen time stamps in the begining
            var lastValue = 0.0
            for elem in elems.reversed(){
                if (elem.timestamp == lastValue) {
                    elem.timestamp -= frameInterval
                    print("Corrected timestamp from \(lastValue) to \(elem.timestamp)")
                }
                lastValue = elem.timestamp
            }

            // normalize timestamp
            //elems = elems.filter({$0.timestamp > 0.0}) // might work
            //elems.removeAll(where: {$0.timestamp != 0.0}) // works
            startTime = elems[0].timestamp
            for elem in elems {
                elem.timestamp = round((elem.timestamp - startTime) * 1000) / 1000
            }
            
            // compute frame rate
            let counter = Double(elems.count)
            if let elapsedTime = elems.last?.timestamp {
                frameInterval = elapsedTime / counter
                frameRate = 1.0 / frameInterval
                //print("Computed frame rate = \(frameRate.description)")
            }
        }
    }
    
    func getFrameRate() -> String {
        // Must be called after normalizeTimestamps() is called
        let rounded = round(frameRate * 1000) / 1000
        return String(format: "%.3f", rounded)
    }
    
    func getValues(index: Int) -> String{
        var result: String = ""
        if elems.count > index{
            for (i, targetLocation) in gTargetList.enumerated(){
                if var val = elems[index].blendShape[targetLocation]?.doubleValue{
                    if val < gSmallestValue{
                        val = 0.000
                    }
                    let doubleStr = String(format: "%.3f", val)
                    if i == 0{
                        result = doubleStr
                    }else{
                        result += ","+doubleStr
                    }
                }else{
                    print("failed to get blendshape value at index \(i)")
                }
            }
        }
        return result
    }
    
    func getTimestamp(index: Int) -> String{
        var result: String = ""
        if elems.count > index{
            result = String(format: "%.3f", elems[index].timestamp)
        }
        return result
    }
    func simdMatrixtToStr(){
        return
    }
    func getMatrix(node: TrackNode,index: Int) -> String{
        //        for (index,faceData) in gFaceDaraArray.enumerated(){
        //            let thisTargetVal = faceData.blendShape[.jawOpen] as? Float
        //            print ("\(faceData.timestamp): jawOpen = \(thisTargetVal)")
        //        }
        //        for (index,faceData) in gFaceDaraArray.enumerated(){
        //            let it1 = faceData.headMatrix[0][0]
        //            let it2 = faceData.headMatrix[3][3]
        //            print ("\(index): headMatrix = \(it1), \(it2)")
        //        }

        var result: String = ""
        for i in (0...3){
            for k in (0...3){
                if (i == 0) && (k == 0){
                    result = String(format: "%.5f", elems[index].headMatrix[i][k])
                }else {
                    result += ","+String(format: "%.5f", elems[index].headMatrix[i][k])
                }
//                print ("matrix [\(i)][\(k)]")
            }
        }
        return result
    }

}
