//
//  JKGotoRecButton.swift
//  FACS-Recorder
//
//  Created by 권영진 on 29/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKGotoRecButton: UIButton {

    var constr: NSLayoutConstraint!
    
    let borderWidth: CGFloat = 1

    let buttWidth: CGFloat = 210
    let buttHeight: CGFloat = 40
    let imageInsetLeft: CGFloat = 74
    let marginBottom: CGFloat = -20
    
    enum alignTo: String {
        case left = "left"
        case right = "right"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(imageName: String, text: String) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: buttWidth, height: buttHeight))
        
        backgroundColor = UIColor.init(displayP3Red: 214/255, green: 255/255, blue: 250/255, alpha: 0.5)
        layer.cornerRadius = buttHeight / 2
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.white.cgColor
        
        setTitle(text, for: .normal)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel?.textAlignment = .left
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 42)
        
        if let image = UIImage(named: imageName) {
            let imageview = UIImageView(image: image)
            imageview.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageview)
            NSLayoutConstraint.activate([
                imageview.widthAnchor.constraint(equalToConstant: 18),
                imageview.heightAnchor.constraint(equalToConstant: 26),
                imageview.centerYAnchor.constraint(equalTo: self.topAnchor, constant: self.frame.height / 2),
                imageview.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
                ])
        }
    }

    func setParent (parentView: UIView){
        
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: buttWidth),
            heightAnchor.constraint(equalToConstant: buttHeight),
            bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: marginBottom),
            ])
        constr = centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0)
        constr.isActive = true
    }
    
    func hideButton (_ isHidden: Bool) {
        
        if let parentView = self.superview {
            
            if isHidden {
                // tweak constraint's constant to how we want to see
                constr.constant = -parentView.frame.width
                UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveLinear, animations: {
                    parentView.layoutIfNeeded()
                })
            } else {
                constr.constant = 0
                UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveLinear, animations: {
                    parentView.layoutIfNeeded()
                })
            }
        }
    }
}
