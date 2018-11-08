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

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtSignInStatus: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tblChatList: UITableView!
    
    var uid: String?
    var refChats: DatabaseReference!
    
    var chats = [ChatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupEnv()
        self.loadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        btnSendClicked(self)
        
        return true
    }
    
    private func setupEnv() {
        self.uid = Auth.auth().currentUser?.uid ?? ""
        self.refChats = Database.database().reference().child("chats")
        
        if Auth.auth().currentUser != nil {
            self.txtSignInStatus.text = Auth.auth().currentUser?.uid
        } else {
            Auth.auth().signInAnonymously { (result, error) in
                if let error = error {
                    print("Error: Sign in anonymously failed! \(error)")
                    return
                }
            }
        }
    }
    
    private func loadData() {
        self.refChats.observe(.value) { (snapshot) in
            if !snapshot.exists() {self.chats.removeAll()}
            
            if snapshot.childrenCount > 0 {
                self.chats.removeAll()
                
                for item in snapshot.children.allObjects as! [DataSnapshot] {
                    let object = item.value as! [String: String]
                    
                    let user = object["user"]
                    let message = object["message"]
                    
                    let chat = ChatModel(user: user, message: message)
                    
                    self.chats.append(chat)
                }
            }
            
            self.tblChatList.reloadData()
        }
    }
    
    private func sendToFirebase(_ message: String) {
        let chat = [
            "user": uid,
            "message": message
        ]

        self.refChats.childByAutoId().setValue(chat)
    }

    @IBAction func btnSendClicked(_ sender: Any) {
        guard let message = txtMessage.text else {return}
        
        txtMessage.text = ""
        
        print("Message: \(message)")
        sendToFirebase(message)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        cell.textLabel?.text = self.chats[indexPath.row].message
        
        return cell
    }
}
