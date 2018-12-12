//
//  JKView.swift
//  FACS-Recorder
//
//  Created by 권영진 on 28/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKView: UIView {
        
    var intrinsicWidth: CGFloat = 1
    var intrinsicHeight: CGFloat = 1
    var nameCase: NameCase = .show // will be deprecated
    
    enum positionCase {
        case upperLeft
        case upperRight
        case upperCenter
        case lowerLeft
        case lowerCenter
        case lowerRight
        case center
        case centerLeft
        case centerRight
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setIntrinsicSize(width: CGFloat, height: CGFloat){
        // custom function to override intrinsic size values
        intrinsicWidth = width
        intrinsicHeight = height
    }
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: intrinsicWidth, height: intrinsicHeight)
    }
    
    // will be deprecated
     func initialize (itsTag: Int) {
     
         tag = itsTag
         nameCase = NameCase.asArray[tag]
     }
    
    func attachToParent(_ parentView: UIView, _ toWhere: positionCase, padX: CGFloat, padY: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: self.frame.width),
            heightAnchor.constraint(equalToConstant: self.frame.height)
            ])
        switch toWhere {
        case .upperLeft:
            NSLayoutConstraint.activate([
                leftAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leftAnchor, constant: padX),
                topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: padY)
                ])
        case .upperRight:
            NSLayoutConstraint.activate([
                rightAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.rightAnchor, constant: -padX),
                topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: padY)
                ])
        case .upperCenter:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerXAnchor, constant: padX),
                topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: padY)
                ])
        case .lowerLeft:
            NSLayoutConstraint.activate([
                leftAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leftAnchor, constant: padX),
                bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -padY)
                ])
        case .lowerRight:
            NSLayoutConstraint.activate([
                rightAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.rightAnchor, constant: -padX),
                bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -padY)
                ])
        case .lowerCenter:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerXAnchor, constant: padX),
                bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: -padY)
                ])
        case .center:
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerXAnchor, constant: padX),
                centerYAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerYAnchor, constant: padY)
                ])
        case .centerLeft:
            NSLayoutConstraint.activate([
                leftAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.leftAnchor, constant: padX),
                centerYAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerYAnchor, constant: padY)
                ])
        case .centerRight:
            NSLayoutConstraint.activate([
                rightAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.rightAnchor, constant: -padX),
                centerYAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerYAnchor, constant: padY)
                ])
        
        }
    }
}
