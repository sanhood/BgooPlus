//
//  CalBtn.swift
//  Begoo
//
//  Created by Danoosh Chamani on 7/4/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit

class CalBtn: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        self.layer.cornerRadius = 3
    }

}
