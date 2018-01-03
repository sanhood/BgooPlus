//
//  ResultCell.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/29/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var Percentage: UILabel!
    @IBOutlet weak var Wrong: UILabel!
    @IBOutlet weak var Correct: UILabel!
    @IBOutlet weak var Count: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
