//
//  Constants.swift
//  FACS-Recorder
//
//  Created by 권영진 on 13/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//
import ARKit

enum NameCase: String, CaseIterable {
    case show = "show"
    case seq = "sequence"
    case shot = "shot"
    case char = "character"
    case take = "take"
    
    static var asArray: [NameCase] {return self.allCases}
    
    func index() -> Int {
        return NameCase.asArray.firstIndex(of: self)!
    }
    
}


let gDefaults = UserDefaults(suiteName: "FACS-Recorder")
let gExtension = "lml"
//var gFaceDaraArray: [FaceData] = []
var gFaceDataBank: FaceDataBank = FaceDataBank()
var gDoCalibrate: Bool = false
var gFaceCalibrated: FaceData!
var gDoRecording: Bool = false
var gCurrentTime: Double = 0.0
let gSmallestValue = 0.001

let gTargetList = [
    // Eyes
    
    ARFaceAnchor.BlendShapeLocation.eyeBlinkLeft,
    
    ARFaceAnchor.BlendShapeLocation.eyeBlinkRight,
    
    ARFaceAnchor.BlendShapeLocation.eyeLookDownLeft,
    
    ARFaceAnchor.BlendShapeLocation.eyeLookDownRight,
    
    ARFaceAnchor.BlendShapeLocation.eyeLookInLeft,
    
    ARFaceAnchor.BlendShapeLocation.eyeLookInRight,
    
    ARFaceAnchor.BlendShapeLocation.eyeLookOutLeft,
    
    ARFaceAnchor.BlendShapeLocation.eyeLookOutRight,
    
    ARFaceAnchor.BlendShapeLocation.eyeLookUpLeft,
    
    ARFaceAnchor.BlendShapeLocation.eyeLookUpRight,
    
    ARFaceAnchor.BlendShapeLocation.eyeSquintLeft,
    
    ARFaceAnchor.BlendShapeLocation.eyeSquintRight,
    
    ARFaceAnchor.BlendShapeLocation.eyeWideLeft,
    
    ARFaceAnchor.BlendShapeLocation.eyeWideRight,
    
    // Mouth and Jaw
    
    ARFaceAnchor.BlendShapeLocation.jawForward,
    
    ARFaceAnchor.BlendShapeLocation.jawLeft,
    
    ARFaceAnchor.BlendShapeLocation.jawRight,
    
    ARFaceAnchor.BlendShapeLocation.jawOpen,
    
    ARFaceAnchor.BlendShapeLocation.mouthClose,
    
    ARFaceAnchor.BlendShapeLocation.mouthFunnel,
    
    ARFaceAnchor.BlendShapeLocation.mouthPucker,
    
    ARFaceAnchor.BlendShapeLocation.mouthLeft,
    
    ARFaceAnchor.BlendShapeLocation.mouthRight,
    
    ARFaceAnchor.BlendShapeLocation.mouthSmileLeft,
    
    ARFaceAnchor.BlendShapeLocation.mouthSmileRight,
    
    ARFaceAnchor.BlendShapeLocation.mouthFrownLeft,
    
    ARFaceAnchor.BlendShapeLocation.mouthFrownRight,
    
    ARFaceAnchor.BlendShapeLocation.mouthDimpleLeft,
    
    ARFaceAnchor.BlendShapeLocation.mouthDimpleRight,
    
    ARFaceAnchor.BlendShapeLocation.mouthStretchLeft,
    
    ARFaceAnchor.BlendShapeLocation.mouthStretchRight,
    
    ARFaceAnchor.BlendShapeLocation.mouthRollLower,
    
    ARFaceAnchor.BlendShapeLocation.mouthRollUpper,
    
    ARFaceAnchor.BlendShapeLocation.mouthShrugLower,
    
    ARFaceAnchor.BlendShapeLocation.mouthShrugUpper,
    
    ARFaceAnchor.BlendShapeLocation.mouthPressLeft,
    
    ARFaceAnchor.BlendShapeLocation.mouthPressRight,
    
    ARFaceAnchor.BlendShapeLocation.mouthLowerDownLeft,
    
    ARFaceAnchor.BlendShapeLocation.mouthLowerDownRight,
    
    ARFaceAnchor.BlendShapeLocation.mouthUpperUpLeft,
    
    ARFaceAnchor.BlendShapeLocation.mouthUpperUpRight,
    
    // Eyebrows
    ARFaceAnchor.BlendShapeLocation.browDownLeft,
    
    ARFaceAnchor.BlendShapeLocation.browDownRight,
    
    ARFaceAnchor.BlendShapeLocation.browInnerUp,
    
    ARFaceAnchor.BlendShapeLocation.browOuterUpLeft,
    
    ARFaceAnchor.BlendShapeLocation.browOuterUpRight,
    
    // Cheeks and Nose
    ARFaceAnchor.BlendShapeLocation.cheekPuff,
    
    ARFaceAnchor.BlendShapeLocation.cheekSquintLeft,
    
    ARFaceAnchor.BlendShapeLocation.cheekSquintRight,
    
    ARFaceAnchor.BlendShapeLocation.noseSneerLeft,
    
    ARFaceAnchor.BlendShapeLocation.noseSneerRight,
    
    // Tongue
    ARFaceAnchor.BlendShapeLocation.tongueOut
]
