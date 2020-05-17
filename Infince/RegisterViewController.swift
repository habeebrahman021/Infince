//
//  RegisterViewController.swift
//  Infince
//
//  Created by Habeeb Rahman on 14/05/20.
//  Copyright © 2020 ZedOne. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
class RegisterViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var statusIndiacator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func registerUser(_ sender: Any) {
        statusIndiacator.startAnimating()
        self.view.isUserInteractionEnabled = false
        let name = txtName.text
        let email = txtEmail.text
        let password = txtPass.text
        Auth.auth().createUser(withEmail: email!, password: password!){ user, error in
            self.statusIndiacator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            if error == nil {
                self.db.collection("users").document(Auth.auth().currentUser!.uid).setData([
                    "id": Auth.auth().currentUser!.uid,
                    "name": name!,
                    "email": email!,
                    "isOnline": false,
                    "last_seen": Date()
                ])
                
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
