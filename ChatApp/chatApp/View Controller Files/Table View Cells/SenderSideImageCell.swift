//
//  SenderSideImageCell.swift
//  chatApp
//
//  Created by axiom1234 on 03/01/2020.
//  Copyright © 2020 Mohammad Arsalan. All rights reserved.
//

import UIKit

class SenderSideImageCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var SenderImageCellView: UIView!{
        didSet{
            SenderImageCellView.layer.cornerRadius  = 10
            //cellView.frame = CGRect(x: 0, y: 0, width: 300, height: )
        }
    }
    
    @IBOutlet weak var MessageImageView: UIImageView!{
        didSet{
            MessageImageView.layer.cornerRadius = 10
            //cellView.frame = CGRect(x: 0, y: 0, width: 300, height: )
        }
    }
}
