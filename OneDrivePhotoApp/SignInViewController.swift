//
//  ViewController.swift
//  OneDrivePhotoApp
//
//  Created by Nihar Reddy on 10/28/21.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signIn() {
        self.performSegue(withIdentifier: "userSignedIn", sender: nil)
    }
}
