//
//  ViewController.swift
//  FirebaseChat Example
//
//  Created by omrobbie on 07/11/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var txtSignInStatus: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tblChatList: UITableView!
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            txtSignInStatus.text = Auth.auth().currentUser?.uid
        } else {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    print("Error: Sign in anonymously failed! \(error)")
                    return
                }
            }
        }
    }
    
    private func sendToFirebase(_ message: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        self.ref = Database.database().reference()

        let data = [
            "user": uid,
            "message": message
        ]
        
        self.ref.child("chats").childByAutoId().setValue(data)
    }
    
    @IBAction func btnSendClicked(_ sender: Any) {
        guard let message = txtMessage.text else {return}
        
        print("Message: \(message)")
        sendToFirebase(message)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "Hello World!"
        
        return cell
    }
}
