//
//  OngoingVC.swift
//  WDMeeting
//
//  Created by Baskaran T on 07/03/17.
//  Copyright © 2017 Baskaran T. All rights reserved.
//

import UIKit

class OngoingVC: UIViewController,SignatureDelegate {

    @IBOutlet weak var signatureView: DrawSignatureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signatureView.delegate = self
        signatureView.layer.borderWidth = 1
        signatureView.layer.borderColor = UIColor.black.cgColor

    }

    @IBAction func btnClear(_ sender: UIButton) {
        self.signatureView.clear()
    }
    
   

    // The delegate methods gives feedback to the instanciating class
    func finishDraw() {
        print("finish")
    }
    
    func startDraw() {
        print("Started")
    }
    
}
