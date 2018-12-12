//
//  JKLabel.swift
//  FACS-Recorder
//
//  Created by 권영진 on 28/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKLabel: UILabel {
    
    var intrinsicWidth: CGFloat = 1
    var intrinsicHeight: CGFloat = 1
    
    func initialize (labelText: String, fontSize: CGFloat, fontWeight: UIFont.Weight) {
        text = labelText
        textColor = .white
        font = UIFont.systemFont(ofSize: fontSize, weight: fontWeight)
        textAlignment = .right
    }
    
    func setIntrinsicSize(width: CGFloat, height: CGFloat){
        intrinsicWidth = width
        intrinsicHeight = height
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }
}
