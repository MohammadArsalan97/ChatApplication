//
//  ReceiverCell.swift
//  chatApp
//
//  Created by axiom1234 on 26/12/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit

class ReceiverCell: UITableViewCell {

    @IBOutlet weak var receiverCellView: UIView!{
        didSet{
            receiverCellView.layer.cornerRadius  = 10
            //cellView.frame = CGRect(x: 0, y: 0, width: 300, height: )
        }
    }
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var receiverMessageBodyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
