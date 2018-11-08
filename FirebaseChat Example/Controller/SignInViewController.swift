//
//  SignInViewController.swift
//  FirebaseChat Example
//
//  Created by omrobbie on 08/11/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit
import Firebase

protocol SignInViewControllerDelegate {
    func updateSignInStatus()
}

class SignInViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var delegate: SignInViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func updataSignInStatus() {
        self.navigationController?.popViewController(animated: true)
        self.delegate?.updateSignInStatus()
    }
    
    @IBAction func btnSignInAnonymouslyClicked(_ sender: Any) {
        signInAnonymouslyDone {
            self.updataSignInStatus()
        }
    }
    
    @IBAction func btnSignInWithEmailClicked(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        signInWithEmail(email: email, password: password) {
            self.updataSignInStatus()
        }
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        registerWithEmail(email: email, password: password) {
            self.updataSignInStatus()
        }
    }
}
