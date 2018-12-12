//
//  RecordViewController
//  FACS-Recorder
//
//  Created by 권영진 on 13/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import ARKit
import SceneKit
import UIKit
import AEXML
import ReplayKit

class RecordViewController: UIViewController, ARSessionDelegate {
    
    // MARK: - Declaration
    
    // prepare for replaykit recording
    var assetWriter: AssetWriter?
    
    let recorder = RPScreenRecorder.shared()
    var fileName = "" // get from FileNameViewController
    
    var currentFaceAnchor: ARFaceAnchor?
    
    // MARK: - Outlets

    var popupMenu: JKPopupMenu!
    var recordButton: JKImageButton!
    var timeLabel: JKTimeCodeLabel!

    @IBOutlet var sceneView: ARSCNView!
    
    deinit {
        print("Deallocate Record ViewController.")
    }
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildTimecodeLabel()
        buildGoBackButton()
        buildCalibrateButton()
        buildPopupMenu()
        buildRecordButton()
        sceneView.delegate = self
        sceneView.session.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        selectedVirtualContent = VirtualContentType(rawValue: popupMenu.selectItem(itemIndex: 2))
    }
    
    func buildRecordButton () {

        recordButton = JKImageButton("record", isToggleOn: false, width: 70, height: 70, borderWidth: 3, bgColor: .clear)
        recordButton.attachToParent(self.view, .lowerCenter, padX: 0, padY: 12)
        recordButton.addTarget(self, action: #selector(recordButtonPressed(_:)), for: .touchUpInside)
    }
    @objc func recordButtonPressed(_ sender: JKImageButton) {
        
        if recordButton.toggleButtonImage(sender) {
            generateHaptic(style: .heavy)
            gFaceDataBank.clear()
            gDoRecording = true
            startCapture()
        }
        else{
            print("Dismiss from Record button.")
            gCurrentTime = 0.0
            timeLabel.reset()
            gDoRecording = false
            stopCapture()
            generateHaptic(style: .heavy)
            writeFaceData()
            showResultView()
        }
    }
    
    func buildPopupMenu () {
        let buttSize = CGSize(width: 50, height: 50)
        popupMenu = JKPopupMenu(["menu","transform","wireframe","shaded"], buttSize: buttSize, startAngle: 90, endAngle: 180, spread: 100)
        popupMenu.attachToParent(self.view, .upperRight, padX: 12, padY: 12)
        for i in (1..<popupMenu.buttons.count){
            popupMenu.buttons[i].addTarget(self, action: #selector(itemButtonPressed(_:)), for: .touchUpInside)
        }
    }
    @objc func itemButtonPressed(_ sender: JKImageButton) {
        selectedVirtualContent = VirtualContentType(rawValue: popupMenu.selectItem(itemIndex: popupMenu.itemButtonSelected(sender: sender)))
    }

    func buildTimecodeLabel() {
        timeLabel = JKTimeCodeLabel(fontSize: 20)
        timeLabel.setParent(parentView: self.view)
    }
    
    func buildGoBackButton() {
        let goBackButt = JKImageButton("left.normal.png", width: 48, height: 48, borderWidth: 2, bgColor: JKColor(0, 0, 0, 0.2).as8BitToUiColor())
        goBackButt.imageEdgeInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 12)
        goBackButt.attachToParent(self.view, .lowerLeft, padX: 12, padY: 12)
        goBackButt.addTarget(self, action: #selector(goBackButtonPressed(_:)), for: .touchUpInside)
    }
    @objc func goBackButtonPressed(_ sender: Any) {
        print("Dismiss from Back button.")
        generateHaptic(style: .medium)
        dismiss(animated: true, completion: nil)
    }
    
    func buildCalibrateButton() {
        let calibButt = JKImageButton("calibration.png", width: 48, height: 48, borderWidth: 0, bgColor: JKColor(0, 0, 0, 0.2).as8BitToUiColor())
        calibButt.attachToParent(self.view, .lowerRight, padX: 12, padY: 12)
        calibButt.addTarget(self, action: #selector(calibrateButtonPressed(_:)), for: .touchUpInside)
    }
    @objc func calibrateButtonPressed(_ sender: Any) {
        generateHaptic(style: .medium)
        gDoCalibrate = true
        gotoCalibrateView()
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoResult"{
            let resultVC = segue.destination as! ResultViewController
            resultVC.fileName = fileName
        }
    }
    
    func showResultView (){

        let resultVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "resultMessage") as! ResultViewController
        resultVC.fileName = fileName
        self.addChild(resultVC)
        resultVC.view.frame = self.view.frame
        self.view.addSubview(resultVC.view)
        resultVC.didMove(toParent: self)
    }
    
    func gotoCalibrateView (){

        let calibVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalibratedResult") as! CalibrateViewController
        present(calibVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // AR experiences typically involve moving the device without
        // touch input for some time, so prevent auto screen dimming.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // "Reset" to run the AR session for the first time.
        resetTracking()
    }

    func generateHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle){
        let hapticGenerator = UIImpactFeedbackGenerator(style: style)
        hapticGenerator.prepare()
        hapticGenerator.impactOccurred()
    }

    func writeFaceData(){
        // Prepare File path
        let documentDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let documentUrl = NSURL(fileURLWithPath: documentDir)
        let fullpathUrl = documentUrl.appendingPathComponent(fileName)!.appendingPathExtension(gExtension)
        if FileManager.default.fileExists(atPath: fullpathUrl.path) {
            do {
                try FileManager.default.removeItem(atPath: fullpathUrl.path)
            } catch {
                print("Failed to remove existing data file: "+fullpathUrl.path)
                print(error.localizedDescription)
            }
            //print("Successfully removed "+fullpathUrl.path)
        }
        // Prepare Face Data
        gFaceDataBank.normalizeTimestamps() // make the time starts from zero
        // Create AEXML
        let xml = AEXMLDocument()
        let data = xml.addChild(name: "data")
        let dataPerSecond = gFaceDataBank.getFrameRate()
        let capturedFrameCount = (assetWriter?.frameCounter)!
        let capturedDataCount = gFaceDataBank.elems.count.description
        let facialDataRoot = data.addChild(name: "FacialMoCap",attributes:[
            "dataPerSecond":dataPerSecond,
            "captruedFrameCount":capturedFrameCount.description,
            "capturedDataCount":capturedDataCount
            ])
        // morph target list
        let targetGroup = facialDataRoot.addChild(name:"morphTargetNames")
        for target in gTargetList{
            targetGroup.addChild(name: "target", attributes: ["name": target.rawValue])
        }
        // Iter each frame data
        let capturedData = facialDataRoot.addChild(name:"capturedData")
        for id in (0..<gFaceDataBank.elems.count){
            let values = gFaceDataBank.getValues(index: id)
            let headMatrix = gFaceDataBank.getMatrix(node: .head, index: id)
            let leftEyeMatrix = gFaceDataBank.getMatrix(node: .lefteye, index: id)
            let rightEyeMatrix = gFaceDataBank.getMatrix(node: .righteye, index: id)
            let attrs = ["values":values,"head":headMatrix,"leftEye":leftEyeMatrix,"rightEye":rightEyeMatrix]
            capturedData.addChild(name: "timestamp", value: gFaceDataBank.getTimestamp(index: id), attributes: attrs)
        }
        // write string to file
        //print(xml.xml)
        do{
            try xml.xml.write(to: fullpathUrl, atomically: true, encoding: String.Encoding.utf8)
        }
        catch let error as NSError {
            print("Failed to write to URL")
            print(error)
        }
    }
    // MARK: Properties

    var contentControllers: [VirtualContentType: VirtualContentController] = [:]
    
    var selectedVirtualContent: VirtualContentType! {
        didSet {
            guard oldValue != nil, oldValue != selectedVirtualContent
                else { return }
            
            // Remove existing content when switching types.
            contentControllers[oldValue]?.contentNode?.removeFromParentNode()
            
            // If there's an anchor already (switching content), get the content controller to place initial content.
            // Otherwise, the content controller will place it in `renderer(_:didAdd:for:)`.
            if let anchor = currentFaceAnchor, let node = sceneView.node(for: anchor),
                let newContent = selectedContentController.renderer(sceneView, nodeFor: anchor) {
                node.addChildNode(newContent)
            }
        }
    }
    var selectedContentController: VirtualContentController {
        if let controller = contentControllers[selectedVirtualContent] {
            return controller
        } else {
            let controller = selectedVirtualContent.makeController()
            contentControllers[selectedVirtualContent] = controller
            return controller
        }
    }

    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didFailWithError error: Error) {
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            self.displayErrorMessage(title: "The AR session failed.", message: errorMessage)
        }
    }
    
    /// - Tag: ARFaceTrackingSetup
    func resetTracking() {
        guard ARFaceTrackingConfiguration.isSupported else { return }
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - Error handling
    
    func displayErrorMessage(title: String, message: String) {
        // Present an alert informing about the error that has occurred.
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.resetTracking()
        }
        alertController.addAction(restartAction)
        present(alertController, animated: true, completion: nil)
    }
}
// MARK: - Scene View Delegate

extension RecordViewController: ARSCNViewDelegate {
        
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        currentFaceAnchor = faceAnchor
        
        // If this is the first time with this anchor, get the controller to create content.
        // Otherwise (switching content), will change content when setting `selectedVirtualContent`.
        if node.childNodes.isEmpty, let contentNode = selectedContentController.renderer(renderer, nodeFor: faceAnchor) {
            node.addChildNode(contentNode)
        }
    }
    
    /// - Tag: ARFaceGeometryUpdate
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard anchor == currentFaceAnchor,
            let contentNode = selectedContentController.contentNode,
            contentNode.parent == node
            else { return }
        // Modifying the autolayout engine from a background thread after the engine was accessed from the main thread can lead to engine corruption and weird crashes.
        // To avoid corruption, do necessary things in the main thread.
        DispatchQueue.main.async {
            if gCurrentTime > 0.0 {
                if gCurrentTime !=  self.timeLabel.lastTime
                {
                    // Shall we start?
                    if self.timeLabel.isHidden {
                        self.timeLabel.isHidden = false
                        self.timeLabel.startTime = gCurrentTime
                    }
                    // Started?
                    self.timeLabel.text = self.timeLabel.formatString(gCurrentTime)
                } else {
                    self.timeLabel.lastTime = gCurrentTime
                }
            } else {
                self.timeLabel.isHidden = true
            }
        }
        selectedContentController.renderer(renderer, didUpdate: contentNode, for: anchor)
    }
}

// MARK: - Asset Writer

extension RecordViewController {
    func startCapture(){
        print("Start Capture")
        assetWriter = AssetWriter(fileName: fileName)
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        RPScreenRecorder.shared().startCapture(handler: { (buffer, bufferType, err) in
            self.assetWriter?.write(buffer: buffer, bufferType: bufferType)
        }, completionHandler: {
            if let error = $0 {
                print (error)
            }
        })
    }
    func stopCapture(){
        print("Stop Capture")
        RPScreenRecorder.shared().stopCapture {
            if let err = $0 {
                print(err)
            }
            self.assetWriter?.finishWriting()
        }
    }
}
