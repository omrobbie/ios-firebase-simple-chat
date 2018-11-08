//
//  GlobalVariables.swift
//  FirebaseChat Example
//
//  Created by omrobbie on 09/11/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import FirebaseDatabase

var uid: String?
var refChat = Database.database().reference().child("chats")
