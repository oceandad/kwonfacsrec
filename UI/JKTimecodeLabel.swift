//
//  JKTimeCodeLabel.swift
//  FACS-Recorder
//
//  Created by 권영진 on 21/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

//enum Framerate: Double {
//    case _23_976 = 23.976
//    case _23_98 = 23.98
//    case _24 = 24.0
//    case _29_97 = 29.97
//    case _30 = 30.0
//    case _59_94 = 59.94
//    case _60 = 60.0
//}

class JKTimeCodeLabel: UILabel {
    var lastTime: Double = 0.0
    var startTime: Double = 0.0
    
    var width: CGFloat = 200  // should be stretchable according to the length of the text
    var height: CGFloat = 30
    var margin: CGFloat = 18
    var fontSize: CGFloat = 20
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(fontSize: CGFloat) {
        self.fontSize = fontSize
        super.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height))
        buildTimecodeLabel()
    }
    
    func buildTimecodeLabel() {

        textAlignment = NSTextAlignment.center
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        textColor = UIColor.white
        isHidden = true
    }
    func setParent(parentView: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        //timeLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.topAnchor, constant: margin),
            centerXAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerXAnchor)
            ])
    }
    
    func reset() {
        startTime = 0.0
        lastTime = 0.0
        text = formatString(0.0)
        isHidden = true
        print(">>>>>> Reset Timecode Label")
    }
    
    func formatString(_ currentTime: Double) -> String {
        
        let elapsedSeconds:Double = currentTime - startTime
        let intSeconds = lrint(elapsedSeconds)
        let minutes = (intSeconds % 3600) / 60
        let seconds = (intSeconds % 3600) % 60
        // Get decimal numbers (numbers after decimal point)
        let decimalNumbers = elapsedSeconds.truncatingRemainder(dividingBy: 1.0)
        let centimilliSecond = Int(round(decimalNumbers * 100))
        //print("decimalNumbers \(decimalNumbers)")
        //let frames = Int(round(decimalNumbers / (1.0 / 60.0)))
        return String(format: "%02d:%02d.%02d", minutes,seconds,centimilliSecond)
    }
    
    
}
