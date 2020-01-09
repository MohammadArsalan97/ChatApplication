//
//  MessageCell.swift
//  chatApp
//
//  Created by axiom1234 on 26/12/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageCell: UIView!{
        didSet{
            messageCell.layer.cornerRadius  = 10
            //cellView.frame = CGRect(x: 0, y: 0, width: 300, height: )
        }
    }
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var messageBodyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   

}
