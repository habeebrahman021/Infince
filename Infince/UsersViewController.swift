//
//  HomeViewController.swift
//  Infince
//
//  Created by Habeeb Rahman on 14/05/20.
//  Copyright © 2020 ZedOne. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct User {
    let id: String?
    let name: String?
    let email: String?
    let isOnline: Bool?
    let lastSeen: Date?
    init?(_ dictionary: [String : Any]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.isOnline = dictionary["isOnline"] as? Bool
        self.lastSeen = dictionary["last_seen"] as? Date
    }
}

class UsersViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var users: [User] = []
    var filteredUsers: [User] = []
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        searchBar.delegate = self
        getUsers()
        
        navigationItem.title = "New Chat"
    }
    
    func getUsers() {
        db.collection("users")
            .addSnapshotListener() { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let dictionaries = documents.compactMap({$0.data()})
                let users_arr = dictionaries.compactMap({User($0)})
                self.users = users_arr.filter{ $0.id != Auth.auth().currentUser?.uid }
                self.filteredUsers = self.users
                self.tableView.reloadData()
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? UsersTableViewCell  else {
            fatalError("The dequeued cell is not an instance.")
        }
        cell.txtName.text = filteredUsers[indexPath.row].name
        cell.txtEmail.text = filteredUsers[indexPath.row].email
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
        homeVc.modalPresentationStyle = .fullScreen
        //let navController = UINavigationController(rootViewController: homeVc)
        homeVc.uid = filteredUsers[indexPath.row].id!
        self.navigationController?.pushViewController(homeVc, animated: true)
            
        guard let navigationController = self.navigationController else { return }
        var navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
        navigationArray.remove(at: navigationArray.count - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.filteredUsers = self.users
        } else {
            self.filteredUsers = users.filter{
                ($0.name?.contains(searchText))!
            }
        }
        tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
}
