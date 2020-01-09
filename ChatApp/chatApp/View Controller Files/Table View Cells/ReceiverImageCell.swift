//
//  ReceiverImageCell.swift
//  chatApp
//
//  Created by axiom1234 on 03/01/2020.
//  Copyright © 2020 Mohammad Arsalan. All rights reserved.
//

import UIKit

class ReceiverImageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var receiverImageCellView: UIView!{
        didSet{
            receiverImageCellView.layer.cornerRadius  = 10
            //cellView.frame = CGRect(x: 0, y: 0, width: 300, height: )
        }
    }
    
    @IBOutlet weak var messageImageView: UIImageView!{
        didSet{
            messageImageView.layer.cornerRadius  = 10
            //cellView.frame = CGRect(x: 0, y: 0, width: 300, height: )
        }
    }
    
}
