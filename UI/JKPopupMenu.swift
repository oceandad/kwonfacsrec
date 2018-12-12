//
//  JKPopupMenu.swift
//  FACS-Recorder
//
//  Created by 권영진 on 06/12/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKPopupMenu: JKView {
    
    var imageNames = [String]()
    var buttons = [JKImageButton]()
    var buttSize = CGSize()
    var points = [CGPoint]()
    var xConstraints = [NSLayoutConstraint]()
    var yConstraints = [NSLayoutConstraint]()
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ buttonImages: [String], buttSize: CGSize, startAngle: CGFloat, endAngle: CGFloat, spread: CGFloat) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: buttSize.width, height: buttSize.height))
        self.imageNames = buttonImages
        self.buttSize = buttSize
        //backgroundColor = UIColor.gray // for debugging
        
        // Compute points for buttons before creation.
        let angleDivider: CGFloat = buttonImages.count > 2 ? CGFloat(buttonImages.count - 2) : 1
        let intervalAngle = (endAngle - startAngle) / angleDivider
        
        let bgColor = UIColor.clear
        for id in (0 ..< buttonImages.count) {
            // The 1st button is the main menu button, set to position (0,0)
            if id == 0 {
                points.append(CGPoint(x: 0, y: 0))
            }
                // Item buttons start from 3 oclock position then rotated
            else {
                let multiplyer = CGFloat(id - 1)
                let toDegree = startAngle + (intervalAngle * multiplyer)
                let rotated = rotatePoint(target: CGPoint(x: spread, y: 0), aroundOrigin: CGPoint(x: 0, y: 0), byDegrees: toDegree)
                points.append(rotated)
            }
        }
        // Compute size of the view to include all child buttons
        self.frame = getBounds()
        // Create each button
        for (id, buttonImage) in buttonImages.enumerated()  {
            
            let imageName = getToggleImageName(buttonImage, false)
            let thisButton = JKImageButton(imageName, width: buttSize.width, height: buttSize.height, borderWidth: 2, bgColor: bgColor)
            thisButton.tag = id
            thisButton.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(thisButton)
            buttons.append(thisButton)
            
            // Layout item buttons to be initially hidden under the menu button
            if id == 0 {
                thisButton.addTarget(self, action: #selector(menuButtonPressed(_:)), for: .touchUpInside)
            } else {
                thisButton.alpha = 0
                thisButton.transform.scaledBy(x: 0.1, y: 0.1)
                //thisButton.addTarget(self, action: #selector(itemButtonPressed(_:)), for: .touchUpInside)
            }
            NSLayoutConstraint.activate([
                thisButton.widthAnchor.constraint(equalToConstant: buttSize.width),
                thisButton.heightAnchor.constraint(equalToConstant: buttSize.height)
                ])
            let xConstr = thisButton.centerXAnchor.constraint(equalTo: leftAnchor, constant: points[0].x)
            xConstr.isActive = true
            let yConstr = thisButton.centerYAnchor.constraint(equalTo: topAnchor, constant: points[0].y)
            yConstr.isActive = true
            xConstraints.append(xConstr)
            yConstraints.append(yConstr)
        }
    }
    
    func getBounds() -> CGRect {
        // get min / max boundary
        var xMax: CGFloat = 0
        var xMin: CGFloat = 0
        var yMax: CGFloat = 0
        var yMin: CGFloat = 0
        for thisPoint in self.points {
            if thisPoint.x > xMax {
                xMax = thisPoint.x
            } else if thisPoint.x < xMin {
                xMin = thisPoint.x
            }
            if thisPoint.y > yMax {
                yMax = thisPoint.y
            } else if thisPoint.y < yMin {
                yMin = thisPoint.y
            }
        }
        // Shift the points to avoid negative coordinates
        let width = xMax + abs(xMin) + buttSize.width
        let height = yMax + abs(yMin) + buttSize.height
        
        for i in (0..<points.count) {
            if xMin < 0 {
                points[i].x += abs(xMin)
            }
            if yMin < 0 {
                points[i].y += abs(yMin)
            }
            // Add offset between the center and the origin (upper left corner) of UIButton
            points[i].x += buttSize.width / 2
            points[i].y += buttSize.height / 2
        }
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    @objc func menuButtonPressed(_ sender: JKImageButton) {
        // button pressed haptic
        let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        hapticGenerator.prepare()
        sender.toggle()
        setButtonImageTo(sender: sender, name: imageNames[sender.tag], toOn: sender.isOn)
        hapticGenerator.impactOccurred()
        
        if sender.isOn{
            // tweak constraint's constant offsets
            for i in (1 ..< buttons.count) {
                //buttons[i].isHidden = false
                xConstraints[i].constant = points[i].x
                yConstraints[i].constant = points[i].y
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
                self.buttons[0].transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                for i in (1 ..< self.buttons.count) {
                    
                    self.buttons[i].transform.scaledBy(x: 1, y: 1)
                    self.buttons[i].alpha = 1
                }
            })
        } else {
            // tweak constraint's constant offsets
            for i in (1 ..< buttons.count) {
                xConstraints[i].constant = points[0].x
                yConstraints[i].constant = points[0].y
            }
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveEaseIn, animations: {
                self.layoutIfNeeded()
                self.buttons[0].transform = CGAffineTransform(rotationAngle: 0)
                for i in (1 ..< self.buttons.count) {
                    self.buttons[i].transform.scaledBy(x: 0.1, y: 0.1)
                    self.buttons[i].alpha = 0
                }
            })
        }
    }
    
    func rotatePoint(target: CGPoint, aroundOrigin origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
        let dx = target.x - origin.x
        let dy = target.y - origin.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx) // in radians
        let newAzimuth = azimuth + byDegrees * CGFloat(CGFloat.pi / 180.0) // convert it to radians
        let x = round(origin.x + radius * cos(newAzimuth))
        let y = round(origin.y + radius * sin(newAzimuth))
        
        return CGPoint(x: x, y: y)
    }
    
    func getToggleImageName(_ baseName: String,_ bool: Bool) -> String {
        
        let boolName = bool ? ".on" : ".off"
        return baseName + boolName + ".png"
    }
    
    func setButtonImageTo(sender: UIButton, name:String, toOn: Bool){
        
        let image = UIImage(named: getToggleImageName(name, toOn))
        sender.setImage(image, for: .normal)
    }
    func selectItem (itemIndex: Int) -> Int {
        
        for id in (1 ..< buttons.count) {
            let imageName = imageNames[id]
            // Selected item? Set to On
            let toOn = id == itemIndex + 1 ? true : false
            let image = UIImage(named: getToggleImageName(imageName, toOn))
            buttons[id].setImage(image, for: .normal)
        }
        return itemIndex
    }
    func itemButtonSelected(sender: JKImageButton) -> Int {
        
        let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)
        hapticGenerator.prepare()
        hapticGenerator.impactOccurred()
        
        return selectItem(itemIndex: sender.tag - 1)
    }
    
}

