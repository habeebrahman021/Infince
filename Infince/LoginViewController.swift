//
//  LoginViewController.swift
//  Infince
//
//  Created by Habeeb Rahman on 14/05/20.
//  Copyright © 2020 ZedOne. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    @IBAction func loginUser(_ sender: Any) {
        self.statusIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        let email = txtEmail.text
        let password = txtPass.text
        Auth.auth().signIn(withEmail: email!, password: password!){ (user, error) in
            self.statusIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if error == nil {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVc = storyBoard.instantiateViewController(withIdentifier: "Home") as! UITabBarController
                homeVc.modalPresentationStyle = .fullScreen
                //let navController = UINavigationController(rootViewController: homeVc)
                self.present(homeVc, animated: true)
            } else {
                let alertVc = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVc.addAction(action)
                self.present(alertVc, animated: true, completion: nil)
            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
