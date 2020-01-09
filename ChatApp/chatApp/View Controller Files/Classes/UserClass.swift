//
//  UserClass.swift
//  chatApp
//
//  Created by Mohammad Arsalan on 02/11/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import Foundation
import UIKit

class User {
    
    var name : String
    var email : String
    var userID : String
    var password : String
    var userImage : String
    
    init(name: String,email: String,password: String,userID: String,userImage : String ) {
        self.name = name
        self.email = email
        self.password = password
        self.userID = userID
        self.userImage = userImage
    }
}
