//
//  JKActivityIndicator.swift
//  FACS-Recorder
//
//  Created by 권영진 on 05/12/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit


class JKActivityIndicator: UIView {
    
    var trackColor = UIColor.lightGray.cgColor
    var hilightColor = JKColor(250, 250, 255, 1).as8BitToCgColor()
    var trackLayer: CAShapeLayer!
    var hilightLayer: CAShapeLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(radius: CGFloat, lineWidth: CGFloat) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        
        let circularPath = UIBezierPath(arcCenter: self.center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor
        trackLayer.lineWidth = lineWidth
        self.layer.addSublayer(trackLayer)
        
        hilightLayer = CAShapeLayer()
        hilightLayer.path = circularPath.cgPath
        hilightLayer.fillColor = UIColor.clear.cgColor
        hilightLayer.strokeColor = hilightColor
        hilightLayer.lineWidth = lineWidth
        hilightLayer.lineCap = CAShapeLayerLineCap.round
        hilightLayer.strokeEnd = 0
        self.layer.addSublayer(hilightLayer)
    }
    func setParent(_ parentView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(self)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: frame.width),
            heightAnchor.constraint(equalToConstant: frame.height),
            centerXAnchor.constraint(equalTo: parentView.centerXAnchor, constant: 0),
            centerYAnchor.constraint(equalTo: parentView.centerYAnchor, constant: 0)
            ])
    }
    func animate(duration: CFTimeInterval){
        let strokeAnim = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnim.toValue = 1
        strokeAnim.duration = duration
        strokeAnim.fillMode = CAMediaTimingFillMode.forwards
        strokeAnim.isRemovedOnCompletion = true
        hilightLayer.add(strokeAnim, forKey: nil)
    }
}
