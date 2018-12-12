//
//  JKButton.swift
//  FACS-Recorder
//
//  Created by 권영진 on 30/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKImageButton: UIButton {
    
    var isOn = false
    
    var size = CGSize()
    var imageName = String()
    
    enum positionCase {
        case upperLeft
        case upperRight
        case upperCenter
        case lowerLeft
        case lowerCenter
        case lowerRight
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ imageName: String, width: CGFloat, height: CGFloat, borderWidth: CGFloat, bgColor: UIColor) {
        
        self.imageName = imageName
        self.size.width = width
        self.size.height = height
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        setImage(UIImage(named: imageName), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
        backgroundColor = bgColor
        layer.cornerRadius = height / 2
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.white.cgColor
    }
    
    init(_ baseName: String, isToggleOn: Bool, width: CGFloat, height: CGFloat, borderWidth: CGFloat, bgColor: UIColor) {
        
        self.imageName = baseName
        self.size.width = width
        self.size.height = height
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        self.isOn = isToggleOn
        setImage(UIImage(named: getToggleImageName()), for: .normal)
        imageView?.contentMode = .scaleAspectFit
        
        backgroundColor = bgColor
        layer.cornerRadius = height / 2
        layer.borderWidth = borderWidth
        layer.borderColor = UIColor.white.cgColor
    }
    
    func toggle() {
        isOn = !isOn
    }
    func getToggleImageName() -> String {
        
        let suffix = isOn ? ".on.png" : ".off.png"
        return imageName + suffix
    }
    
    func toggleButtonImage(_ sender: UIButton) -> Bool{
        
        toggle()
        sender.setImage(UIImage(named: getToggleImageName()), for: .normal)
        return isOn
    }
    
    func attachToParent(_ parentView: UIView, _ toWhere: positionCase, padX: CGFloat, padY: CGFloat) {

        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size.width),
            heightAnchor.constraint(equalToConstant: size.height)
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
        }
    }
}
