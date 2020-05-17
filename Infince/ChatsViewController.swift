//
//  ChatsViewController.swift
//  Infince
//
//  Created by Habeeb Rahman on 15/05/20.
//  Copyright © 2020 ZedOne. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

struct Chat {
    let members: [String]?
    let member_names: [String]?
    let last_message: String?
    let last_time: Date?
    init?(_ dictionary: [String : Any]) {
        self.member_names = dictionary["member_names"] as? [String]
        self.members = dictionary["members"] as? [String]
        self.last_message = dictionary["last_message"] as? String
        self.last_time = (dictionary["last_time"] as? Timestamp)?.dateValue()
    }
}
class ChatsViewController: UIViewController {
    let db = Firestore.firestore()
    var my_id: String = Auth.auth().currentUser!.uid
    var chats: [Chat] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //tabBarController?.tabBar.isHidden = false
        
        tableView.delegate = self
        tableView.dataSource = self
        getChats()
    }
    
    func getChats() {
        
        db.collection("chats")
            //.whereField("members", arrayContains: my_id)
            .order(by: "last_time")
            .addSnapshotListener() { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                let dictionaries = documents.compactMap({$0.data()})
                self.chats = dictionaries.compactMap({Chat($0)})
                self.tableView.reloadData()
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chat_segue" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            var user_id: String = "0"
            for id in chats[indexPath!.row].members!{
                if id != Auth.auth().currentUser?.uid {
                    user_id = id
                }
            }
            let chatViewController = segue.destination as! ChatViewController
            chatViewController.uid = user_id
        }
    }
    

}
extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chats.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatsTableViewCell
        
        for (index, value) in chats[indexPath.row].members!.enumerated(){
            if value != Auth.auth().currentUser?.uid {
                cell.lblName.text = chats[indexPath.row].member_names![index]
            }
        }
        
        cell.lblMessage.text = chats[indexPath.row].last_message
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: chats[indexPath.row].last_time!)
        cell.lblTime.text = time
        return cell
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        for id in chats[indexPath.row].members!{
//            if id != Auth.auth().currentUser?.uid {
//                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let homeVc = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
//                homeVc.modalPresentationStyle = .fullScreen
//                //let navController = UINavigationController(rootViewController: homeVc)
//                homeVc.uid = id
//                self.navigationController?.pushViewController(homeVc, animated: true)
//            }
//        }
//
//    }
    
    
}
