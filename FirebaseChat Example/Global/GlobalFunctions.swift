//
//  GlobalFunctions.swift
//  FirebaseChat Example
//
//  Created by omrobbie on 08/11/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import Firebase

func signInAnonymouslyDone(completion: @escaping () -> ()) {
    Auth.auth().signInAnonymously { (result, error) in
        if let error = error {
            print("Error: Sign in anonymously failed! \(error.localizedDescription)")
            return
        }
        
        completion()
    }
}

func signInWithEmail(email: String, password: String, completion: @escaping () -> ()) {
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
        if let error = error {
            print("Error: Sign in with email failed! \(error.localizedDescription)")
            return
        }
        
        completion()
    }
}

func registerWithEmail(email: String, password: String, completion: @escaping () -> ()) {
    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
        if let error = error {
            print("Error: Create new user with email failed! \(error.localizedDescription)")
            return
        }
        
        completion()
    }
}

func signOutSuccess() -> Bool {
    if Auth.auth().currentUser?.isAnonymous ?? false {
        Auth.auth().currentUser?.delete(completion: { (error) in
            if let error = error {
                print("Error: Delete anonymous user failed! \(error.localizedDescription)")
                return
            }
        })
    }
    
    do {
        try Auth.auth().signOut()
    } catch {
        print("Error: Sign out failed!")
        return false
    }
    
    return true
}

func sendChatToFirebase(message: String) -> Bool {
    if Auth.auth().currentUser == nil {return false}
    
    let chat = [
        "user": uid,
        "message": message
    ]
    
    refChat.childByAutoId().setValue(chat)
    
    return true
}
