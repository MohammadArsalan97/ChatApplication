//
//  ConversationCell.swift
//  chatApp
//
//  Created by Mohammad Arsalan on 02/11/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: CustomImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userMessageLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
