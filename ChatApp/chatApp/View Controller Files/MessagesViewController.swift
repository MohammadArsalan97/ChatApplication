//
//  MessagesViewController.swift
//  chatApp
//
//  Created by Mohammad Arsalan on 09/11/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import AVFoundation

class MessagesViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioRecorderDelegate {
    
    var recordingSession : AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVPlayer!
    
    var audioURL : String?
    
    var indexPathRowForSenderImage : Int?
    var indexPathRowForSenderAudio : Int?
    var uid = Auth.auth().currentUser?.uid
    var recipientName : String?
    var recipientID : String?
    var recieverName = ""
    var recieverID = ""
    //var convoID = ""
    var sharedRef = UIApplication.shared.delegate as! AppDelegate
    var chat : ConversationUser?
    var newChat : User?
    var conversationID = ""
    var userDataDict = [String:Any]()
    var messageArray : [Message] = [Message]()
    var messageDB : ListenerRegistration?
    var image = UIImage(named: "user-23")
    
    
    
    var senderID = ""
    var msg = ""
    
    
    var convoIdArray : [String] = []
    {
        didSet
        {
            self.convoIdArray.sort{ (a,b) -> Bool in return a > b }
        }
    }

    @IBOutlet weak var audioBtnOutlet: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var sendBtnOutlet: UIButton!
    @IBOutlet weak var messageTextView: UITextView!
    
    func settingUpAudioSession() {
        recordingSession = AVAudioSession.sharedInstance()
        
        recordingSession.requestRecordPermission { (hasPermission) in
            if hasPermission{
                print("ACCEPTED!")
            }
        }
    }
    
    func getDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func displayAlert(title: String,message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
   
    
    func getData() {
        let docRef = self.sharedRef.database.collection("Users").document(self.uid!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.userDataDict = document.data()!
                print("Document data: \(self.userDataDict)")
            } else {
                print("Document does not exist")
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated) // No need for semicolon
//        retrieveMessages()
//    }
    
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        messageDB?.remove()
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.messageTableView.scrollToRow(at: 4 as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
        settingUpAudioSession()
        
        if let number: Int = UserDefaults.standard.object(forKey: "myNumber") as? Int{
            numberOfRecords = number
        }
        
       // self.messageTableView.estimatedRowHeight = 110
        //self.messageTableView.separatorColor = UIColor .clear
        getData()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        
        if let conversationID = chat?.conversationID{
            self.conversationID = conversationID
            print(self.conversationID)
        }
        
        
        if let recipientId = newChat?.userID{
            recieverID = recipientId
            print(recieverID)
        }
        if let recipientId = chat?.recipientID{
            recieverID = recipientId
            print(recieverID)
        }
        //----------------
        if let recipientname = newChat?.name{
            recieverName = recipientname
            print(recieverName)
        }
        if let recipientname = chat?.name{
            recieverName = recipientname
            print(recieverName)
        }
        
//        if let recipientURL = recipientImageUrl{
//            recieverImageUrl = recipientURL
//            print(recieverImageUrl)
//        }
//        if let recipientURL = chat?.imageURL{
//            recieverImageUrl = recipientURL
//            print(recieverImageUrl)
//        }
        
//        recipientID = (chat?.recipientID)!
//        recipientName = (chat?.name)!
        
//        recieverID = recipientID!
//        recieverName = recipientName!
//        
//        print(recieverID)
//        print(recieverName)
        
        
        messageTextView.delegate = self
        
        messageTextView.clipsToBounds = true
        messageTextView.layer.cornerRadius = 10.0
       

        messageTextView.isScrollEnabled = false
        
        retrieveMessages()
       // retriveMessages1()
    }
    
    
    @IBAction func addBtn(_ sender: Any) {
        
        // create Image Picker Controller
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil )
        
    }
    // image picker controller delegate function
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    // image picker controller delegate function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker : UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
         //call function upload image to firebase store
            uploadImageOnFirebase(image: selectedImage)
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func uploadImageOnFirebase(image : UIImage?) {
        let uniqueId = UUID()
        let uid = Auth.auth().currentUser?.uid
        var imageReference : StorageReference{
            return Storage.storage().reference().child("Image-Messages").child(uid!)
        }
        let filename = "\(uniqueId)-Image.jpg"
        
        let uploadImageRef = imageReference.child(filename)
        
        
        guard let image = image else {
            return
        }
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else {
            return
        }
        
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print(error)
            }else{
                
                uploadImageRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error)
                    }else{
                        
                        print(url?.absoluteString)
                        
                            var imageMessageDict : [String: Any?] = [
                                //"isSender" : self.isSender,
                                "messageType" : "image",
                                "messageContent" : (url?.absoluteString)!,
                                "senderID" : self.uid,
                                //"imageUrl" : (url?.absoluteString)!,
                                "recipientID": self.recieverID,
                                "recipientName" : self.recieverName,
                                //"recipientImageUrl" :self.recieverImageUrl,
                                "timeStamp" : FieldValue.serverTimestamp(),
                                "conversationID" : self.conversationID
                            ]
                            //  print(updateDict["imageUrl"])
                            let chatDocRef = self.sharedRef.database.collection("Message").document().setData(imageMessageDict, completion: { (error) in
                                if error == nil {
                                    //self.uploadImageOnFirebase()

                                   // self.performSegue(withIdentifier: "toTabBarFromSignUp", sender: nil)

                                }else
                                {
                                    print(error?.localizedDescription)
                                }
                            })
                        
                        // self.sharedRef.database.collection("Users").document(uid!).updateData(updateDict)
                    }
                })
            }
            
            print("Upload Task Finised")
            print(metadata ?? "No Metadata")
            print(error ?? "No Error")
            
        }
        
        
        uploadTask.resume()
        // uploadTask.removeAllObservers()
    }
    
    
    
    @IBAction func sendBtn(_ sender: Any) {
        if messageTextView.text == ""{
            self.sendBtnOutlet.isEnabled = false
        }
        messageTextView.endEditing(true)
        messageTextView.isEditable = false
        sendBtnOutlet.isEnabled = false
        
//        var Users = [String]()
//        Users.append(self.uid!)
//        Users.append(self.recieverID)
        
        convoIdArray.append(self.uid!)
        convoIdArray.append(self.recieverID)
        
        conversationID = convoIdArray[0] + convoIdArray[1]
        print(conversationID)
        
        
        var messageDict : [String: Any?] = [
            //"isSender" : self.isSender,
            "messageType" : "text",
            "senderID" : self.uid,
            "messageContent" : messageTextView.text,
            "recipientID": self.recieverID,
            "recipientName" : self.recieverName,
            //"imageUrl" : nil,
            //"recipientImageUrl" :self.recieverImageUrl,
            "timeStamp" : FieldValue.serverTimestamp(),
            "conversationID" : self.conversationID
        ]
        let senderConversationDict: [String:Any] = [
            "messageContent" : messageTextView.text,
            "recipientName" : self.recieverName,
            "recipientID" : self.recieverID,
            //"recepientImageUrl" : self.recieverImageUrl,
            "senderID": self.uid,
            "senderName" : userDataDict["name"],
           // "senderImageUrl" : userDataDict["imageUrl"],
            "conversationID" : self.conversationID,
            "users" : convoIdArray,
           // "isSender" : isSender,
            "time" : FieldValue.serverTimestamp()
        ]
        let recieverConversationDict: [String:Any] = [
            "messageContent" : messageTextView.text,
            "recipientName" : userDataDict["name"],
            "recipientID" : self.uid,
           // "recepientImageUrl" : userDataDict["imageUrl"],
            //            "senderID": ,
            //            "senderName" : ,
            //            "senderImageUrl" : ,
          //  "isSender" : false,
            "conversationID" : self.conversationID,
            "users" : convoIdArray,
            "time" : FieldValue.serverTimestamp()
        ]
        
        
        
        // Get new write batch
        let batch = self.sharedRef.database.batch()
        
        // Set the value of 'ConversationID'
        let senderRef = self.sharedRef.database.collection("Conversation").document(self.uid!).collection("Inbox").document(self.recieverID)
        batch.setData(senderConversationDict, forDocument: senderRef)
        
        // Set the value of 'ConversationID'
        let receiverRef = self.sharedRef.database.collection("Conversation").document(self.recieverID).collection("Inbox").document(self.uid!)
        batch.setData(recieverConversationDict, forDocument: receiverRef)
        
        // Set the value of 'Message'
        let chatDocRef = self.sharedRef.database.collection("Message").document()
        batch.setData(messageDict, forDocument: chatDocRef)
        
        // Commit the batch
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write succeeded.")
                self.convoIdArray.removeAll()
                
                self.messageTextView.isEditable = true
                self.sendBtnOutlet.isEnabled = true
                self.messageTextView.text = ""

               // self.retrieveMessages()
            }
        }
        

        
    }
    var numberOfRecords = 0
    @IBAction func audioBtn(_ sender: Any) {
        // Check if we have an active recorder
        
        if audioRecorder == nil{
            
            
            numberOfRecords += 1
            let filename = getDirectory().appendingPathComponent("\(numberOfRecords).m4a")
            
            let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey: 1, AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
            // Start Audio Recording
            do{
                print("Start Recording...")
                audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
            }
            catch{
                displayAlert(title: "Oops", message: "Recoding Failed")
            }
        }else{
            let url =  getDirectory().appendingPathComponent("\(numberOfRecords).m4a").absoluteString
            
            // Stop Audio Recording
            print("Sop Recording...")
            audioRecorder.stop()
            audioRecorder = nil
            uploadAudioFileOnFirebase(path: url)
            UserDefaults.standard.set(numberOfRecords, forKey: "myNumber")
            print(numberOfRecords)
        }
        
    }
    func uploadAudioFileOnFirebase(path :String?) {
        let uniqueId = UUID()
        let uid = Auth.auth().currentUser?.uid
        var audioFileReference : StorageReference{
            return Storage.storage().reference().child("audio-Messages").child(uid!)
        }
        let filename = "\(uniqueId)-audioMessage.m4a"

        let uploadAudioRef = audioFileReference.child(filename)


//        guard let audio = path else {
//            return
//        }
        
//        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else {
//            return
//        }

        let uploadTask = uploadAudioRef.putFile(from: URL(string: path!)!, metadata: nil) { (metadata, error) in
            if let error = error {
                print(error)
            }else{
                
                uploadAudioRef.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                    }else{
                        
                        print(url?.absoluteString)
                        
                        var audioMessageDict : [String: Any?] = [
                            //"isSender" : self.isSender,
                            "messageType" : "audio",
                            "messageContent" : (url?.absoluteString)!,
                            "senderID" : self.uid,
                            //"imageUrl" : (url?.absoluteString)!,
                            "recipientID": self.recieverID,
                            "recipientName" : self.recieverName,
                            //"recipientImageUrl" :self.recieverImageUrl,
                            "timeStamp" : FieldValue.serverTimestamp(),
                            "conversationID" : self.conversationID
                        ]
                        //  print(updateDict["imageUrl"])
                        let chatDocRef = self.sharedRef.database.collection("Message").document().setData(audioMessageDict, completion: { (error) in
                            if error == nil {
                                print("Audio file send to firebase Successfully!")
                            }else
                            {
                                print(error?.localizedDescription)
                            }
                        })
                    }
                })
            }
            
            print("Upload Task Finised")
            print(metadata ?? "No Metadata")
            print(error ?? "No Error")

        }
       


        uploadTask.resume()
        // uploadTask.removeAllObservers()
    }

    
    
//    func retriveMessages1()  {
//        self.sharedRef.database.collection("Message").whereField("conversationID", isEqualTo: self.conversationID).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//
//                    self.senderID = document.data()["senderID"]! as! String
//                    print(self.senderID)
//                    self.msg = document.data()["messageContent"]! as! String
//                    let conID = document.data()["conversationID"]!
//                    // self.isSender = diff.document.data()["isSender"]! as! Bool
//                    let reciID = document.data()["recipientID"]! as! String
//                    var date : Date?
//                    var getDate : Timestamp?
//                    if let timestamp = document.data()["timeStamp"] as? Timestamp{
//                        date = timestamp.dateValue()
//                        print(date)
//                    }else{
//                        date = Date()
//                    }
//
//                    //                        let getDate = diff.document.data()["timeStamp"] as! Timestamp
//                    //                        let date = getDate.dateValue()
//                    // Date format for sorting messages
//                    let dateFormatter = DateFormatter()
//                    dateFormatter.dateStyle = .short
//                    dateFormatter.timeStyle = .short
//                    let strDate = dateFormatter.string(from: date!)
//                    print(strDate)
//                    print(date)
//
//                    // Time Format For showing on message
//                    let timeFormatter = DateFormatter()
//                    timeFormatter.dateStyle = .none
//                    timeFormatter.timeStyle = .short
//                    let strTime = timeFormatter.string(from: date!)
//                    print(strTime)
//                    print(date)
//                    //                        self.timeArray.append(str)
//                    //                        self.timeArray.sort()
//                    //                        print(self.timeArray)
//
//                    //                        self.timeArray.append(date!)
//                    //                        self.timeArray.sort()
//                    //                        print(self.timeArray)
//
//                    let message = Message(senderID: self.senderID, messageBody: self.msg, convoID: conID as! String, recipientID: reciID, time: strTime, date: strDate, imageUrl: <#String#>)
//                    self.messageArray.append(message)
//
//                    self.messageArray = self.messageArray.sorted(by: { $0.date < $1.date })
//
//
//
//
//                    // self.configureTableView()
//                    self.messageTableView.reloadData()
//
//
//                }
//
//
//        }
//        }
//    }
    
    
    func retrieveMessages() {
        messageDB = self.sharedRef.database.collection("Message").whereField("conversationID", isEqualTo: self.conversationID).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            
            
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    self.senderID = diff.document.data()["senderID"]! as! String
                    print(self.senderID)
                    self.msg = diff.document.data()["messageContent"]! as! String
                    let conID = diff.document.data()["conversationID"]!
                   // self.isSender = diff.document.data()["isSender"]! as! Bool
                    let reciID = diff.document.data()["recipientID"]! as! String
                    let messageType = diff.document.data()["messageType"] as! String
                    //let imageUrl = diff.document.data()["imageUrl"] as! String
                    
                    var date : Date?
                    var getDate : Timestamp?
                    if let timestamp = diff.document.data()["timeStamp"] as? Timestamp{
                        date = timestamp.dateValue()
                        print(date)
                    }else{
                        date = Date()
                    }
                    
                    //                        let getDate = diff.document.data()["timeStamp"] as! Timestamp
                    //                        let date = getDate.dateValue()
                    // Date format for sorting messages
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .short
                    dateFormatter.timeStyle = .short
                    let strDate = dateFormatter.string(from: date!)
                    print(strDate)
                    print(date)
                    
                    // Time Format For showing on message
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateStyle = .none
                    timeFormatter.timeStyle = .short
                    let strTime = timeFormatter.string(from: date!)
                    print(strTime)
                    print(date)
                    //                        self.timeArray.append(str)
                    //                        self.timeArray.sort()
                    //                        print(self.timeArray)
                    
                    //                        self.timeArray.append(date!)
                    //                        self.timeArray.sort()
                    //                        print(self.timeArray)
                    
                    let message = Message(senderID: self.senderID, messageBody: self.msg, convoID: conID as! String, recipientID: reciID, time: strTime, date: strDate, messageType: messageType)
                    self.messageArray.append(message)
                    
                    self.messageArray = self.messageArray.sorted(by: { $0.date < $1.date })
                    
                    
                    
                    
                   // self.configureTableView()
                    self.messageTableView.reloadData()
                    //self.messageTableView.scrollsToTop
                    
                }
                //completion(self.sortedArray,nil)
                
            }
            
            
        }
        
        
    }
    
    //let indexPath = NSIndexPath(item: self.messageArray.count, section: 0)
    
    
}
//extension MessagesViewController: AudioCellDelegate{
//    func didTapPlayButton(url: String) {
//        let audioURL = URL(string: url)
//        do {
//            try audioPlayer = AVAudioPlayer(contentsOf: audioURL!)
//            audioPlayer.play()
//            print("Audio Playing......")
//        } catch  {
//            //Error
//        }
//    }
//    
//    
//}

