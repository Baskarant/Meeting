//
//  ViewController.swift
//  WDMeeting
//
//  Created by Baskaran T on 07/03/17.
//  Copyright © 2017 Baskaran T. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtADID: UITextField!
    @IBOutlet weak var txtpwd: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // password field text is hidden
        txtpwd.isSecureTextEntry = true
    }
    
    
    @IBAction func btnLogin(_ sender: UIButton) {
        // Dummy login
        if (txtADID.text == "admin") && (txtpwd.text == "admin") {
            // if username and password is correct redirect to next page
            self.performSegue(withIdentifier: "loginSeque", sender: self)
        }else{
            print("False")
        }
    }
  
}

