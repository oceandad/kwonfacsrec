//
//  JKColor.swift
//  FACS-Recorder
//
//  Created by 권영진 on 05/12/2018.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class JKColor {
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 0.0
    init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) {
        r = red
        g = green
        b = blue
        a = alpha
    }
    func as8BitToUiColor() -> UIColor {
        return UIColor.init(red: a/255, green: g/255, blue: b/255, alpha: a)
    }
    func as8BitToCgColor() -> CGColor {
        return UIColor.init(red: a/255, green: g/255, blue: b/255, alpha: a).cgColor
    }
}
