//
//  ConversationClass.swift
//  chatApp
//
//  Created by axiom1234 on 26/12/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import Foundation
import  UIKit

class ConversationUser {
    
    var name : String
    var message : String
    var recipientID : String
    var conversationID : String
   // var time : String
   // var imageURL : String
    //var count : Int
    
    init(name : String, message: String,recipientID : String, conversationID : String) {
        self.conversationID = conversationID
        self.recipientID = recipientID
        //self.imageURL = imageURL
        self.name = name
        self.message = message
        //self.time = time
        //self.imageURL = imageURL
        //self.count = count
    }
    
}
