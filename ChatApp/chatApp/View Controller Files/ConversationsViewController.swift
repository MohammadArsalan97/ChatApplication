//
//  ConversationsViewController.swift
//  chatApp
//
//  Created by Mohammad Arsalan on 02/11/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ConversationsViewController: UIViewController {
    
    
    var name = ""
   // var imgUrl = ""
    var message = ""
    //var image =
    var recipientID : String?
    var conversationUserObject : ConversationUser?
   // var convoArray = [String]()
    var convoUserData = [ConversationUser]()
    var uid = Auth.auth().currentUser?.uid
    var sharedRef = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var conversationSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveMessages()
        conversationTableView.delegate = self
        conversationTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    //@IBAction func unwindToConversationVC(segue: UIStoryboardSegue) {
        
    //}
   
    @IBOutlet weak var conversationTableView: UITableView!
    
    func retrieveMessages() {
        
        let messageDB = self.sharedRef.database.collection("Conversation").document(self.uid!).collection("Inbox").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    
                    
                    self.recipientID = diff.document.data()["recipientID"] as! String
                    self.message = diff.document.data()["messageContent"] as! String
                    var convoID = diff.document.data()["conversationID"] as! String
                    
                    // Date time Formatter
                    
//                    var date : Date?
//                    var getDate : Timestamp?
//                    if let timestamp = diff.document.data()["time"] as? Timestamp{
//                        date = timestamp.dateValue()
//                        print(date)
//                    }else{
//                        date = Date()
//                    }
//                    let formatter = DateFormatter()
//                    formatter.dateStyle = .none
//                    formatter.timeStyle = .short
//                    let str = formatter.string(from: date!)
//                    print(str)
//                    print(date)
                    
                    //                        let result = convoID.split(separator: "_")
                    //                        print(result)
                    //                        let parsed = convoID.replacingOccurrences(of: "_", with: "")
                    //                        let againParsed = parsed.replacingOccurrences(of: self.uid!, with: "")
                    //                        print(parsed)
                    //                        print(againParsed)
                    //                        if againParsed == self.uid{
                    //                            print(self.uid!)
                    //                        }else{
                    //
                    //                        }
                    
                    self.name = diff.document.data()["recipientName"] as! String
                   // self.imgUrl = diff.document.data()["recepientImageUrl"] as! String
                    
                    
                    
                    print(self.name,self.message)
                   // print(self.imgUrl)
                    
                    self.conversationUserObject = ConversationUser(name: self.name, message: self.message, recipientID: self.recipientID!, conversationID: convoID)
                    self.convoUserData.append(self.conversationUserObject!)
                    
                    DispatchQueue.main.async{
                        self.conversationTableView.reloadData()
                    }
                    
                }
                if (diff.type == .modified) {
                    
                    
                    
                    self.name = diff.document.data()["recipientName"] as! String
                    self.message = diff.document.data()["messageContent"] as! String
                    print(self.name,self.message)
                    
                    self.convoUserData.filter {$0.name == self.name}.first?.message = self.message
                    
                    
                    DispatchQueue.main.async{
                        self.conversationTableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    
    
    
    
    @IBAction func composeNewMessage(_ sender: Any) {
        self.performSegue(withIdentifier: "toNewChat", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewChat" {
            let destVC = segue.destination as! NewChatViewController
           // destVC.chat = sender as! User?
            destVC.hidesBottomBarWhenPushed = true
            //destVC.navigationItem.title = destVC.chat?.name
            
        }
        if segue.identifier == "chatsToMessages" {
            let destVC = segue.destination as! MessagesViewController
            destVC.chat = sender as! ConversationUser
            destVC.hidesBottomBarWhenPushed = true
            destVC.navigationItem.title = destVC.chat?.name
            
        }
        if segue.identifier == "newChatToMessages" {
            let destVC = segue.destination as! MessagesViewController
            destVC.chat = sender as! ConversationUser
            destVC.hidesBottomBarWhenPushed = true
            destVC.navigationItem.title = destVC.chat?.name
            
        }
    }
    
    
}

extension ConversationsViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convoUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell") as! ConversationCell
        
        cell.userNameLbl.text = convoUserData[indexPath.row].name
        cell.userMessageLbl.text = convoUserData[indexPath.row].message
        cell.userImageView.image = UIImage(named: "user-23")
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = self.convoUserData[indexPath.row]
        performSegue(withIdentifier: "chatsToMessages", sender: chat)
        
    }
    
}
