//
//  CustomButton.swift
//  BloodBankApplication
//
//  Created by Mohammad Arsalan on 06/04/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit

@IBDesignable class CustomButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func round() {
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 0
       // self.layer.backgroundColor = UIColor.red.cgColor
        self.layer.backgroundColor = Colors.uiView1.cgColor
       // self.layer.borderColor = widthColor.cgColor
        self.clipsToBounds = true
    }
    
//    override func draw(_ rect: CGRect) {
//
//        self.setNeedsDisplay()
//    }
//
//    @IBInspectable var cornerRadius:CGFloat = 0{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//
//    @IBInspectable var cornerWidth:CGFloat = 0{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
//
//    @IBInspectable var widthColor:UIColor = UIColor.red{
//        didSet{
//            self.setNeedsDisplay()
//        }
//    }
    
    @IBInspectable var isCircle:Bool = false{
        didSet{
            round()
        }
    }
    

}
