//
//  JKUpdownButtonGrp.swift
//  FACS-Recorder
//
//  Created by 권영진 on 28/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class JKIncrementButton: UIButton {
    
    var isUp: Bool!
    var targetTF: UITextField!
    
    let buttWidth: CGFloat = 40
    let buttHeight: CGFloat = 30
    let insetVertical: CGFloat = 8
    let insetHorizontal: CGFloat = 8
    let cornerRadius: CGFloat = 10
    enum AlignTo: String {
        case left = "left"
        case right = "right"
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(imageName: String, isIncrement: Bool, targetTextfield: UITextField) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: buttWidth, height: buttHeight))
        
        isUp = isIncrement
        targetTF = targetTextfield
        
        setImage(UIImage(named: imageName), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: insetVertical, left: insetHorizontal, bottom: insetVertical, right: insetHorizontal)
        backgroundColor = .clear
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = cornerRadius
        addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
    }
    
    @objc func buttonPressed(sender: UIButton){
        
        let hapticGenerator = UISelectionFeedbackGenerator()
        hapticGenerator.prepare()
        
        let adder = isUp ? 1 : -1
        
        if let thisStr = targetTF.text {
            let numberPaddingCount = thisStr.count
            if var thisVal = Int(thisStr.trimmingCharacters(in: NSCharacterSet.whitespaces)) {
                thisVal += adder
                if thisVal < 1 {
                    thisVal = 1
                }
                targetTF.text = String(format: "%0"+String(numberPaddingCount)+"d", thisVal)
            }
        }
        hapticGenerator.selectionChanged()
    }
    
    func setParent(parentView: UIView, alignTo: AlignTo, inset: CGFloat) {
        // layout
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor, constant: inset),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: inset),
            widthAnchor.constraint(equalToConstant: buttWidth),
            heightAnchor.constraint(equalToConstant: buttHeight)
            ])
        if alignTo == .left {
            leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: inset).isActive = true
        } else {
            rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: inset).isActive = true
        }
    }
    

}
