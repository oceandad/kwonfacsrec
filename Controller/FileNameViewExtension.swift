//
//  TextFieldInputs.swift
//  FACS-Recorder
//
//  Created by 권영진 on 23/11/2018.
//  Copyright © 2018 권영진. All rights reserved.
//

import Foundation
import UIKit

extension FileNameViewController: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    static var textFieldDic = [NameCase:JKTextField]()
    static var switchesDic = [NameCase:JKSwitchButton]()
    
    
    public func buildInputTextFieldUnit() {
        
        let margin: CGFloat = 8
        let rowHeight: CGFloat = 30
        let columnWidth1: CGFloat  = 240
        let columnWidth2: CGFloat  = 260
        let columnWidth3: CGFloat  = 300
        let labelFontSize: CGFloat = 18
        let labelFontWeight: UIFont.Weight = .bold
        let stackVerticalPosRatio: CGFloat = 0.4
        enum GapSpace: CGFloat {
            case stackHorizontal = 8
            case stackVertical = 36
        }
        
        FileNameViewController.textFieldDic.removeAll()
        FileNameViewController.switchesDic.removeAll()
        
        let fieldDic: [NameCase:String] = [
            .show:"Show Name",
            .seq:"Sequence Name",
            .shot:"Shot Number",
            .char:"Character Name",
            .take:"Take Number"
            ]
        let fieldKeyboardType: [NameCase:UIKeyboardType] = [
            .show:UIKeyboardType.default,
            .seq: UIKeyboardType.numberPad,
            .shot: UIKeyboardType.numberPad,
            .char: UIKeyboardType.default,
            .take: UIKeyboardType.numberPad
        ]

        let vertStack = JKStackColumn(spacing: GapSpace.stackVertical.rawValue, distribution: .fillEqually)
        
        // MARK: - Create each row of Label + TF + View Group
        
        for thisNameCase in NameCase.allCases {
            
            let thisLabel = JKLabel()
            thisLabel.initialize(labelText: thisNameCase.rawValue.capitalized, fontSize: labelFontSize, fontWeight: labelFontWeight)
            thisLabel.setIntrinsicSize(width: columnWidth1, height: rowHeight)
            
            let thisTF = JKTextField()
            thisTF.initialize(itsTag: thisNameCase.index(), itsHolder: fieldDic[thisNameCase]!, itsKeyboardType: fieldKeyboardType[thisNameCase]!)
            thisTF.setIntrinsicSize(width: columnWidth2, height: rowHeight)
            thisTF.delegate = self
            FileNameViewController.textFieldDic[thisNameCase] = thisTF
            
            let thisView = JKView()
            thisView.initialize(itsTag: thisNameCase.index())
            thisView.setIntrinsicSize(width: columnWidth3, height: rowHeight)

            let thisStack = JKStackRow([thisLabel,thisTF,thisView], spacing: GapSpace.stackHorizontal.rawValue, distribution: .fillProportionally)
            vertStack.addArrangedSubview(thisStack)
            
            // attach extra
            buildInputSwitchButton(parentView: thisView)
        }

        view.addSubview(vertStack)
        vertStack.setParent(parentView: view, itsMargin: margin, positionRatio: stackVerticalPosRatio)
        
        buildUpDownButtons()
    }

    // MARK: Input Switch Button
    
    func buildInputSwitchButton (parentView: UIView) {
        
        let thisSwitch = JKSwitchButton()
        thisSwitch.setParent(parentView: parentView)
        FileNameViewController.switchesDic[NameCase.asArray[parentView.tag]] = thisSwitch
        thisSwitch.addTarget(self, action: #selector(inputSwitchButtonPressed), for: .touchUpInside)
    }
    @objc func inputSwitchButtonPressed (sender: JKSwitchButton) {
        
        view.endEditing(true)
        sender.buttonPressed()
        currActiveCase = NameCase.asArray[sender.tag]
        FileNameViewController.textFieldDic[currActiveCase]?.becomeFirstResponder()
    }
        
    // MARK: Up/Down Buttons for Take
    
    func buildUpDownButtons() {
        
        let posOffsetX: CGFloat = -40
        let posOffsetY: CGFloat = -300
        
        let upButton = JKIncrementButton(imageName: "up.normal.png", isIncrement: true, targetTextfield: FileNameViewController.textFieldDic[.take]!)
        let downButton = JKIncrementButton(imageName: "down.normal.png", isIncrement: false, targetTextfield: FileNameViewController.textFieldDic[.take]!)
        let groupWidth: CGFloat = upButton.frame.width + downButton.frame.width + 4
        let groupHeight: CGFloat = upButton.frame.height
        let groupView = UIView(frame: CGRect(x: 0, y: 0, width: groupWidth, height: groupHeight))

        // layout
        groupView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(groupView)

        NSLayoutConstraint.activate([
            groupView.widthAnchor.constraint(equalToConstant: groupWidth),
            groupView.heightAnchor.constraint(equalToConstant: groupHeight),
            groupView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: posOffsetX),
            groupView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: posOffsetY)
            ])

        upButton.setParent(parentView: groupView, alignTo: .right, inset: 0)
        downButton.setParent(parentView: groupView, alignTo: .left, inset: 0)
    }
    
    // MARK: TextField Utilities and Delegate Functions
    
    func updateTextfieldsFromHistory(){
        for key in NameCase.allCases{
            if (userdata.hasRecentDict[key]!){
                if let lastValue = userdata.recentListDict[key]?.last {
                    FileNameViewController.textFieldDic[key]?.text = lastValue
                }
            }
        }
    }
    
    func textFieldDidUpdate(){
        for key in NameCase.allCases{
            if let thisVal = FileNameViewController.textFieldDic[key]?.text {
                userdata.set(key: key, val: thisVal.trimmingCharacters(in: NSCharacterSet.whitespaces))
            }
        }
        // Check if the name is ready and toggle visibility of "new" button accordingly
        print("text field did update isHidden: \(userdata.isNameReady())")
        gotoRecButton.hideButton(!userdata.isNameReady())
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // by pressing "Return", it hides keyboard
        self.view.endEditing(true)
        //textField.resignFirstResponder()
        textFieldDidUpdate()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // by touching outside a textfield, it hides keyboard
        
        self.view.endEditing(true)
        textFieldDidUpdate()
    }

    // MARK: Picker View
    
    // requires self as a textfield delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {

        currActiveCase = NameCase.asArray[textField.tag]
        
        if FileNameViewController.switchesDic.keys.contains(currActiveCase) {
            
            if FileNameViewController.switchesDic[currActiveCase]!.isOn {
                picker.delegate = self
                picker.dataSource = self
                textField.inputView = picker
                return
            }
        }
        // otherwise we show keyboard
        textField.inputView = nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return (userdata.recentListDict[currActiveCase]?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return userdata.recentListDict[currActiveCase]?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (userdata.recentListDict[currActiveCase]?.count)! > row {
            FileNameViewController.textFieldDic[currActiveCase]?.text = userdata.recentListDict[currActiveCase]?[row]
        }
        view.endEditing(true)
    }
}
