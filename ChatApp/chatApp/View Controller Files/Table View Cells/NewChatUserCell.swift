//
//  NewChatUserCell.swift
//  chatApp
//
//  Created by Mohammad Arsalan on 08/11/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit

class NewChatUserCell: UITableViewCell {

    @IBOutlet weak var newChatUserImageView: CustomImageView!
    
    @IBOutlet weak var newChatUserNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
