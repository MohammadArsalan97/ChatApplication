//
//  NewChatViewController.swift
//  chatApp
//
//  Created by Mohammad Arsalan on 08/11/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit
import FirebaseAuth
import SDWebImage
import FirebaseStorage

class NewChatViewController: UIViewController {

    var uid = Auth.auth().currentUser?.uid
    var sharedRef = UIApplication.shared.delegate as! AppDelegate
    var image = UIImage(named: "user-23")
    
    @IBOutlet weak var newChatUserSearchBar: UISearchBar!
    
    @IBOutlet weak var newChatTableView: UITableView!
    var userArray: [User] = []
    var userObject : User?
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(cancel))
        newChatTableView.delegate = self
        newChatTableView.dataSource = self
       getData()
        // Do any additional setup after loading the view.
    }
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
        //self.navigationController?.dismiss(animated: true)
    }
    
    
    
    
    func getData() {
        let userRef = self.sharedRef.database.collection("Users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    var dataDescription = document.data()
                    
                    var name = dataDescription["name"] as! String
                    var email = dataDescription["email"] as! String
                    var userId = dataDescription["userID"] as! String
                    var profileImage = (dataDescription["imageUrl"] as? String)!
                    
                    
                    self.userObject = User(name: name, email: email , password: "nil", userID: userId, userImage: profileImage)
                    self.userArray.append(self.userObject!)
                    self.userArray = self.userArray.filter { $0.userID != self.uid }
                    print(self.userArray)
                    DispatchQueue.main.async{
                        self.newChatTableView.reloadData()
                    }
                   
                }
            }
        }
    }
    
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newChatToMessages" {
            let destVC = segue.destination as! MessagesViewController
            destVC.newChat = sender as! User
            destVC.hidesBottomBarWhenPushed = true
            destVC.navigationItem.title = destVC.newChat?.name
            
        }
        
    }
    

}

extension NewChatViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChatUserCell") as! NewChatUserCell
        
        cell.newChatUserNameLbl.text = self.userArray[indexPath.row].name
        //cell.newChatUserImageView.image = UIImage(named: "user-23")
        let url = URL(string: self.userArray[indexPath.row].userImage )

        cell.newChatUserImageView.sd_setImage(with: url as! URL, placeholderImage: self.image)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newChat = self.userArray[indexPath.row]
        performSegue(withIdentifier: "newChatToMessages", sender: newChat)
        
    }
}
