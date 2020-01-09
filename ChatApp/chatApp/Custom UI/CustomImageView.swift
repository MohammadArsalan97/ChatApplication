//
//  CustomImageView.swift
//  BloodBankApplication
//
//  Created by Mohammad Arsalan on 04/05/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit

@IBDesignable class CustomImageView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var ISCircle: Bool = false {
        didSet {
            setImageInCircle()
            
        }
    }
    
    
    
    func setImageInCircle()
    {
        if ISCircle {
            //self.layer.borderWidth
            self.layer.masksToBounds = false
            //image.layer.borderColor = UIColor.black.cgColor
            self.layer.cornerRadius = self.frame.height/2
            self.clipsToBounds = true
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1.5;
        } else {
           // self.layer.masksToBounds = false
            //image.layer.borderColor = UIColor.black.cgColor
            self.layer.cornerRadius = 0
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1.5;
            //self.clipsToBounds = true
        }
        
        
    }

}
