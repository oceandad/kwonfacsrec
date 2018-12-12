//
//  JKStackColumn.swift
//  FACS-Recorder
//
//  Created by 권영진 on 28/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKStackColumn: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(spacing: CGFloat, distribution: UIStackView.Distribution) {

        super.init(frame: CGRect())
        
        axis = .vertical
        alignment = .center
        self.distribution = distribution
        self.spacing = spacing
        
    }
    
    func setParent(parentView: UIView, itsMargin: CGFloat, positionRatio: CGFloat) {
        // layout
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: parentView.leftAnchor, constant: itsMargin),
            rightAnchor.constraint(equalTo: parentView.rightAnchor, constant: itsMargin),
            centerYAnchor.constraint(equalTo: parentView.topAnchor, constant: parentView.frame.height * positionRatio)
            ])
    }
    
}
