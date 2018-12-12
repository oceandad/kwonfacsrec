//
//  SwitchButton.swift
//  FACS-Recorder
//
//  Created by 권영진 on 28/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class JKSwitchButton: UIButton {
    
    var isOn = false
    
    var width: CGFloat = 82
    var height: CGFloat = 30
    
    var onTitle: String = "Recent .."
    var offTitle: String = "Keyboard"
    var onTitleColor: UIColor = .black
    var offTitleColor: UIColor = .white
    var onBackGroundColor: UIColor = .white
    var offBackGroundColor: UIColor = .clear
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize () {
        // Look Decoration
        layer.borderWidth = 1
        layer.cornerRadius = height / 2
        layer.borderColor = onBackGroundColor.cgColor
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        setTitle(offTitle, for: .normal)
        setTitleColor(offTitleColor, for: .normal)
    }
    func setParent(parentView: UIView) {
        
        tag = parentView.tag
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.topAnchor, constant: 0),
            bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: 0),
            leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: 0),
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
            ])
    }
    func setSimpleSwitchColors (mainColor: UIColor, titleColorWhenOn: UIColor) {
        onTitleColor = titleColorWhenOn
        offTitleColor = mainColor
        onBackGroundColor = mainColor
        offBackGroundColor = .clear
        layer.borderColor = mainColor.cgColor
    }
    func setSwitchTitles(titleWhenOn: String, titleWhenOff: String) {
        
        onTitle = titleWhenOn
        offTitle = titleWhenOff
    }
    func buttonPressed(){
        
        activateButton(bool: !isOn)
    }
    func activateButton (bool: Bool) {
        
        isOn = bool
        
        let hapticGenerator = UISelectionFeedbackGenerator()
        hapticGenerator.prepare()
        
        let thisBGColor = isOn ? onBackGroundColor : offBackGroundColor
        let thisTitleColor = isOn ? onTitleColor : offTitleColor
        let thisTitle = isOn ? onTitle : offTitle
        
        backgroundColor = thisBGColor
        setTitleColor(thisTitleColor, for: .normal)
        setTitle(thisTitle, for: .normal)
        hapticGenerator.selectionChanged()
    }
}


