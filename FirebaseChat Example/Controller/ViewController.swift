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

class ViewController: UIViewController, UITextFieldDelegate, SignInViewControllerDelegate {

    @IBOutlet weak var txtSignInStatus: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tblChatList: UITableView!
    @IBOutlet weak var btnSignInAndOut: UIBarButtonItem!
    
    var chats = [ChatModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupEnv()
        self.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! SignInViewController
        
        destination.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        btnSendClicked(self)
        
        return true
    }
    
    func updateSignInStatus() {
        if Auth.auth().currentUser != nil {
            self.txtSignInStatus.text = Auth.auth().currentUser?.uid
            self.btnSignInAndOut.title = "Sign Out"
        } else {
            signInAnonymouslyDone {
                self.txtSignInStatus.text = uid
                self.btnSignInAndOut.title = "Sign Out"
            }
        }

        uid = Auth.auth().currentUser?.uid
    }
    
    private func setupEnv() {
        self.updateSignInStatus()
    }
    
    private func loadData() {
        refChat.observe(.value) { (snapshot, error) in
            if let error = error {
                print("Error: Load data error! \(String(error.description))")
            }
            if !snapshot.exists() {self.chats.removeAll()}
            
            if snapshot.childrenCount > 0 {
                self.chats.removeAll()
                
                for object in snapshot.children.allObjects as! [DataSnapshot] {
                    let item = object.value as! [String: String]
                    
                    let id = object.key
                    let user = item["user"]
                    let message = item["message"]

                    let chat = ChatModel(id: id, user: user, message: message)

                    self.chats.append(chat)
                }
            }
            
            self.tblChatList.reloadData()
        }
    }
    
    @IBAction func btnSendClicked(_ sender: Any) {
        guard let message = txtMessage.text else {return}
        
        if sendChatToFirebase(message: message) {
            txtMessage.text = ""
            print("Message: \(message)")
        }
    }
    
    @IBAction func btnSignInAndOutClicked(_ sender: Any) {
        if btnSignInAndOut.title == "Sign In" {
            self.performSegue(withIdentifier: "toSignIn", sender: self)
        } else {
            if signOutSuccess() {
                print("Sign out success!")
                txtSignInStatus.text = "Please sign in.."
                btnSignInAndOut.title = "Sign In"
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let user = self.chats[indexPath.row].user

        if user == uid {
            cell.textLabel?.textAlignment = .right
            cell.textLabel?.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.backgroundColor = #colorLiteral(red: 0.9688743949, green: 0.9631143212, blue: 0.9733015895, alpha: 1)
        }
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.chats[indexPath.row].message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let id = chats[indexPath.row].id {
                refChat.child(id).removeValue()
            }
        }
    }
}
