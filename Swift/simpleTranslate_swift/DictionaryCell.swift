//
//  DictionaryCell.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 26.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import Foundation
import UIKit

class DictionaryCell: UITableViewCell {
    
    @IBOutlet weak var dictTextLabel: UILabel!
    @IBOutlet weak var dictTranslateLabel: UILabel!
    @IBOutlet weak var fromToLabel: UILabel!
    
    var _translate:STTranslate?   
    func translate(tr:STTranslate!) {
        _translate = tr
        dictTextLabel.text = tr.request
        dictTranslateLabel.text = tr.responce
        fromToLabel.text = String(format: "%@-%@", tr.fromLangKey ?? "", tr.toLangKey ?? "")
    }
    
    
    
//    @property (weak, nonatomic) IBOutlet UILabel *dictTextLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *dictTranslateLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *fromToLabel;
//    
//    @property (weak, nonatomic) STTranslate *translateObject;
}
