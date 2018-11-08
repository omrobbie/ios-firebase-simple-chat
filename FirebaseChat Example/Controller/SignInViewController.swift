//
//  SignInViewController.swift
//  FirebaseChat Example
//
//  Created by omrobbie on 08/11/18.
//  Copyright © 2018 omrobbie. All rights reserved.
//

import UIKit

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
    
    @IBAction func btnSignInAnonymouslyClicked(_ sender: Any) {
        signInAnonymouslyDone {
            self.navigationController?.popViewController(animated: true)
            self.delegate?.updateSignInStatus()
        }
    }
    
    @IBAction func btnSignInWithEmailClicked(_ sender: Any) {
        print(#function)
    }
    
    @IBAction func btnRegisterClicked(_ sender: Any) {
        print(#function)
    }
}
