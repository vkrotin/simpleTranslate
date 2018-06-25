//
//  UIColor+Extension.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 31.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
