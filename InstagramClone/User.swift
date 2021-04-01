//
//  User.swift
//  InstagramClone
//
//  Created by Lova Krishna on 26/04/20.
//  Copyright © 2020 Lova Krishna. All rights reserved.
//

import UIKit

struct User {
    var username      : String
    var profileurl    : String
    var posts         : Int
    var followers     : Int
    var following     :  Int
    
   init(data: [String: Any]) {
    self.username = data["username"] as? String ?? ""
    self.profileurl = data["profile"] as? String ?? ""
    self.posts = data["posts"] as? Int ?? 0
    self.followers = data["followers"] as? Int ?? 0
    self.following = data["following"] as? Int ?? 0
    }
}
