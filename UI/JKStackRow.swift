//
//  JKStackRow.swift
//  FACS-Recorder
//
//  Created by 권영진 on 28/11/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKStackRow: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ childViews: [UIView], spacing: CGFloat, distribution: UIStackView.Distribution) {
        let cgrect = CGRect()
        super.init(frame: cgrect)
        for thisView in childViews {
            addArrangedSubview(thisView)
        }
        axis = .horizontal
        alignment = .center
        self.distribution = distribution //.fillProportionally
        self.spacing = spacing
    }
    
}
