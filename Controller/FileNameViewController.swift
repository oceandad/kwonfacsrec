//
//  FileNameViewController.swift
//  FACS-Recorder
//
//  Created by 권영진 on 12/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class FileNameViewController: UIViewController {
    
    var fileName: String = ""
    var userdata: UserData = UserData()
    
    @IBOutlet weak var titleLabel: UILabel!
    var gotoRecButton = JKGotoRecButton()
    var picker = UIPickerView()
    var currActiveCase: NameCase = .show
    
    
    // MARK: View Controls
    
    deinit {
        print("Deallocate File Name ViewController.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // FOR DEBUGGING ONLY START
        //clearUserDefault()
        // FOR DEBUGGING ONLY END
        buildInputTextFieldUnit()
        buildGotoRecButton()
        //Textfield update from recently saved user inputs
        fetchUserDefaults()
        updateTextfieldsFromHistory()
    }

    override func viewDidAppear(_ animated: Bool) {
        // Check if the name is ready and toggle visibility of "new" button accordingly
        print("view did appear isName ready: \(userdata.isNameReady())")
        gotoRecButton.hideButton(!userdata.isNameReady())
    }
    // MARK: Navigation to Recording Session
    
    func buildGotoRecButton() {
        
        gotoRecButton = JKGotoRecButton(imageName: "right.normal.png", text: "Go to Session")
        gotoRecButton.setParent(parentView: view)
        gotoRecButton.addTarget(self, action: #selector(gotoRecButtonPressed), for: .touchUpInside)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoRecording"{
            let recordingVC = segue.destination as! RecordViewController
            recordingVC.fileName = userdata.fileName
        }
    }
    @objc func gotoRecButtonPressed(){
        // button pressed haptic
        let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        hapticGenerator.prepare()
        hapticGenerator.impactOccurred()
        // save inputs for a later use
        storeUserDefaults()
        // go to the recording view controller
        gotoRecButton.constr.constant = view.frame.width * 1.3
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (finished) in
            self.performSegue(withIdentifier: "gotoRecording", sender: self)
        }
    }

    // MARK: - User Defaults

    func clearUserDefault(){
        for thisKey in NameCase.allCases {
            gDefaults?.removeObject(forKey: thisKey.rawValue)
        }
        gDefaults?.synchronize()
    }
    
    func storeUserDefaults(){
        //print("===== Store user defaults data")
        userdata.recordRecentNames()
        for thisKey in NameCase.allCases{
            gDefaults?.set(userdata.recentListDict[thisKey], forKey: thisKey.rawValue)
            //print("      has value for \(thisKey.rawValue) : \(userdata.recentListDict[thisKey])")
        }
        gDefaults?.synchronize()
    }
    
    func fetchUserDefaults(){
        //print("===== Fetch user defaults data")
        for thisKey in NameCase.allCases{
            if let thisList = gDefaults?.array(forKey: thisKey.rawValue) as? [String]{
                if thisList.count > 0 {
                    userdata.setRecent(key: thisKey, recentList: thisList)
                    //print("      has value for \(thisKey.rawValue) : \(thisList)")
                }
            }
        }
    }
    
}
