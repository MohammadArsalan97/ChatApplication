//
//  MessageClass.swift
//  chatApp
//
//  Created by axiom1234 on 28/12/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import Foundation
import UIKit

class Message {
    var messageType : String?
    var senderID : String?
    var messageBody : String
  //  var isSender : Bool
    var convoID : String?
    var recipientID : String?
    var time : String?
    var date : String
   // var imageUrl : String?
    //    var count : Int
    
    init(senderID : String, messageBody : String, convoID : String, recipientID : String, time : String, date : String, messageType : String?) {
        self.senderID = senderID
        self.messageBody = messageBody
      //  self.isSender = isSender
        self.convoID = convoID
        self.recipientID = recipientID
        self.time = time
        self.date = date
        self.messageType = messageType
       // self.imageUrl = imageUrl
    }
    
//    func method(arg: Bool, completion: (Bool) -> ()) {
//        print("First line of code executed")
//        // do stuff here to determine what you want to "send back".
//        // we are just sending the Boolean value that was sent in "back"
//        completion(arg)
//    }
//    func two(){
//        
//        method(arg: true, completion: { (success) -> Void in
//            print("Second line of code executed")
//            if success { // this will be equal to whatever value is set in this method call
//                print("true")
//            } else {
//                print("false")
//            }
//        })    }
}
