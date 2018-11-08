//
//  ChatModel.swift
//  FirebaseChat Example
//
//  Created by omrobbie on 08/11/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

class ChatModel {
    var user: String?
    var message: String?
    
    init(user: String?, message: String?) {
        self.user = user
        self.message = message
    }
}
