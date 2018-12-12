//
//  JKTextField.swift
//  FACS-Recorder
//
//  Created by 권영진 on 28/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKTextField: UITextField {

    var intrinsicWidth: CGFloat = 1
    var intrinsicHeight: CGFloat = 1
    var nameCase: NameCase = .show
    
    func initialize(itsTag: Int, itsHolder: String, itsKeyboardType: UIKeyboardType) {
        tag = itsTag
        nameCase = NameCase.asArray[tag]
        placeholder = itsHolder
        keyboardType = itsKeyboardType
        keyboardAppearance = .dark
        autocorrectionType = .no
        layer.cornerRadius = 6
        backgroundColor = .white
        textColor = .black
        clearButtonMode = .always
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: intrinsicHeight))
        leftView = paddingView
        leftViewMode = .always
    }
    
    func setIntrinsicSize(width: CGFloat, height: CGFloat){
        intrinsicWidth = width
        intrinsicHeight = height
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }
    
}
