//
//  EmptyBackgroundView.swift
//  simpleTranslate_swift
//
//  Created by Aleksey Anisimov on 30.05.17.
//  Copyright © 2017 Aleksey Anisimov. All rights reserved.
//

import UIKit

class LoadingTableViewEmpty: UIView {
    
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyTextLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("LoadingTableViewEmpty", owner: self, options: nil)
        view.frame = self.frame
        addSubview(view)
    }
    
    
  
}
