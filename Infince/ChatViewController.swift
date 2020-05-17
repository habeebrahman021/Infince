//
//  ChatViewController.swift
//  Infince
//
//  Created by Habeeb Rahman on 14/05/20.
//  Copyright © 2020 ZedOne. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
struct Message{
    let message: String?
    let receiver: String?
    let sender: String?
    let date: Date?
    let time: Date?
    init?(_ dictionary: [String : Any]) {
        self.message = dictionary["message"] as? String
        self.receiver = dictionary["receiver"] as? String
        self.sender = dictionary["sender"] as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MMM/yyyy"
        
        let mdate = (dictionary["time"] as? Timestamp)?.dateValue()
        let ndate = formatter.string(from: mdate ?? Date())
        
        self.date = formatter.date(from: ndate)
        self.time = (dictionary["time"] as? Timestamp)?.dateValue()
    }
}
class ChatViewController: UIViewController {
    let db = Firestore.firestore()
    var uid: String = ""
    var myid: String = Auth.auth().currentUser!.uid
    var my_name: String?
    var u_name: String?
    var messages: [Message] = []
    var chat_messages = [[Message]]()
    let cell_id = "cell_chat"
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var tableView: UITableView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tabBarController?.tabBar.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ChatCell.self, forCellReuseIdentifier: cell_id)
        // Do any additional setup after loading the view.
        getUserDetails()
        getMessages()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let date = Date()
        let message = txtMessage.text!
        var chat_id: String = ""
        if myid > uid{
            chat_id = myid + "-" + uid
        } else {
            chat_id = uid + "-" + myid
        }
        let chat_data = [
            "members": [myid, uid],
            "member_names": [my_name, u_name],
            "last_message": message,
            "last_time": date
            ] as [String : Any]
        let msg_data = [
            "message": message,
            "sender": myid,
            "receiver": uid,
            "time": date
            ] as [String : Any]
        db.collection("chats").document(chat_id).setData(chat_data)
        db.collection("chats").document(chat_id).collection("messages").addDocument(data: msg_data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else{
                self.txtMessage.text = nil
            }
        }
    }
    func getUserDetails() {
        db.collection("users").document(uid)
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
            self.navigationItem.title = document.get("name") as? String
            self.u_name = document.get("name") as? String
          
        }
        db.collection("users").document(myid)
        .addSnapshotListener { documentSnapshot, error in
          guard let document = documentSnapshot else {
            print("Error fetching document: \(error!)")
            return
          }
            self.my_name = document.get("name") as? String
          
        }
    }
    
    func getMessages() {
        var chat_id: String = ""
        if myid > uid{
            chat_id = myid + "-" + uid
        } else {
            chat_id = uid + "-" + myid
        }
        
        db.collection("chats")
            .document(chat_id)
            .collection("messages")
            .order(by: "time")
            .addSnapshotListener() { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                self.chat_messages.removeAll()
                let dictionaries = documents.compactMap({$0.data()})
                self.messages = dictionaries.compactMap({Message($0)})
                
                let groupedMessages = Dictionary(grouping: self.messages){ (element) -> Date in
                    element.date!
                }
                
                groupedMessages.keys.sorted().forEach{ (key) in
                    self.chat_messages.append(groupedMessages[key] ?? [])
                }
                self.tableView.reloadData()
                self.tableView.scrollToBottom()
                
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
extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return chat_messages.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chat_messages[section].count
    }
    class DateHeaderLabel: UILabel {
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .black
            textColor = .white
            textAlignment = .center
            translatesAutoresizingMaskIntoConstraints = false
            font = UIFont.boldSystemFont(ofSize: 14)
        }
        required init?(coder: NSCoder) {
            fatalError("")
        }
        override var intrinsicContentSize: CGSize{
            
            let originalContentSize = super.intrinsicContentSize
            let height = originalContentSize.height+12
            layer.cornerRadius = height/2
            layer.masksToBounds = true
            return CGSize(width: originalContentSize.width+16, height: height)
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = DateHeaderLabel()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        let firstMessage = chat_messages[section].first
        if Calendar.current.isDateInToday((firstMessage?.time)!) {
            label.text = "Today"
        } else if Calendar.current.isDateInYesterday((firstMessage?.time)!) {
            label.text = "Yesterday"
        } else {
            label.text = formatter.string(from: (firstMessage?.time)!)
        }
        let containerView = UIView()
         containerView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        
    
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cell_id, for: indexPath) as! ChatCell
        let msg = chat_messages[indexPath.section][indexPath.row]
        cell.lblMessage.text = msg.message
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: msg.time!)
        cell.lblTime.text = time
        cell.isIncoming = msg.sender == uid
        return cell
    }
    
    
}
extension UITableView {

    func scrollToBottom(){

        DispatchQueue.main.async {
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func scrollToTop() {

        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            self.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}

