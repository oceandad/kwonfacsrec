/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Displays the 3D face mesh geometry provided by ARKit, with a static texture.
 */

import ARKit
import SceneKit

class DefaultFaceMask: NSObject, VirtualContentController {
    
    var contentNode: SCNNode?
    
    /// CreateARSCNFaceGeometry
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

        guard let sceneView = renderer as? ARSCNView,
            anchor is ARFaceAnchor else { return nil }
        
        #if targetEnvironment(simulator)
        #error("ARKit is not supported in iOS Simulator. Connect a physical iOS device and select it as your Xcode run destination, or select Generic iOS Device as a build-only destination.")
        #else
        let faceGeometry = ARSCNFaceGeometry(device: sceneView.device!)!
        
        //faceGeometry.firstMaterial?.fillMode = .fill
        let material = faceGeometry.firstMaterial!
        material.diffuse.contents = UIColor.lightGray
        material.lightingModel = .physicallyBased
        
        contentNode = SCNNode(geometry: faceGeometry)
        #endif
        return contentNode
    }
    
    /// ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceGeometry = node.geometry as? ARSCNFaceGeometry,
            let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        // Record if asked
        if gDoRecording && gCurrentTime > 0.0 {
            //let facedata = FaceData(bsDict: faceAnchor.blendShapes, headMat: faceAnchor.transform, leftEyeMat: faceAnchor.leftEyeTransform, rightEyeMat: faceAnchor.rightEyeTransform,time: Date().timeIntervalSince1970)
            let facedata = FaceData(bsDict: faceAnchor.blendShapes, headMat: faceAnchor.transform, leftEyeMat: faceAnchor.leftEyeTransform, rightEyeMat: faceAnchor.rightEyeTransform,time: gCurrentTime)
            gFaceDataBank.elems.append(facedata)
        }
        else if gDoCalibrate {
            DispatchQueue.main.async {
                gFaceCalibrated = FaceData(bsDict: faceAnchor.blendShapes, headMat: faceAnchor.transform, leftEyeMat: faceAnchor.leftEyeTransform, rightEyeMat: faceAnchor.rightEyeTransform,time: gCurrentTime)
                gDoCalibrate = false
            }
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
    }
}
