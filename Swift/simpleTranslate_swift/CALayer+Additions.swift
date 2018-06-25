//
//  CALayer+Additions.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 26.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

extension CALayer{
    
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
    
    var shadowUIColor: UIColor {
        set{
            self.shadowColor = newValue.cgColor
        }
        get{
            return UIColor(cgColor: self.shadowColor!)
        }
    }


}
