//
//  SignUpViewController.swift
//  chatApp
//
//  Created by Mohammad Arsalan on 25/10/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var sharedRef = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var userImageView: CustomImageView!
    @IBOutlet weak var nameTextField: CustomTextField!
    
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userImageView.image = UIImage(named: "user-23")
        tapGestureOnImageView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // tap gesture on imageview
    func tapGestureOnImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImageView.isUserInteractionEnabled = true
        userImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        showImagePicker()
        // Your action
    }
    // show Image picker function
    func showImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action : UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                
                print("Camera not available")
            }
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action : UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    // picker view delegate functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let userImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        userImageView.image = userImage
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // create user function
    func createUser() {
        if let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text{
//            let dict: [String: Any] =
//                ["name": name,
//                 "email": email,
//                 "userID": Auth.auth().currentUser?.uid  ]
            
            Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                if user != nil{
                 
                    
                    self.uploadImageOnFirebase()
//                self.sharedRef.database.collection("Users").document((Auth.auth().currentUser?.uid)!).setData(dict, completion: { (err) in
//                        if err == nil {
//                            self.sharedRef.database.collection("Users").document((Auth.auth().currentUser?.uid)!).updateData([
//                                "userID": Auth.auth().currentUser?.uid
//                            ]) { err in
//                                if let err = err {
//                                    print("Error updating document: \(err)")
//                                } else {
//                                    print("Document successfully updated")
//                                }
//                            }
//                            self.performSegue(withIdentifier: "toTabBarFromSignUp", sender: nil)
//                        }else{
//                            // show error description
//                            print(err?.localizedDescription)
//                        }
//                    })
                }else{
                    print(error?.localizedDescription)
                }
            })
        
            
        }
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        createUser()
    }
    
    @IBAction func signInBtn(_ sender: Any) {
    }
    func uploadImageOnFirebase() {
        
        let uid = Auth.auth().currentUser?.uid
        var imageReference : StorageReference{
            return Storage.storage().reference().child("images").child(uid!)
        }
        let filename = "\(uid)-profileImage.jpg"
        
        let uploadImageRef = imageReference.child(filename)
        
        
        guard let image = userImageView.image else {
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
                        if let name = self.nameTextField.text, let email = self.emailTextField.text, let password = self.passwordTextField.text, let url = url?.absoluteString{
                        
                        let dict: [String:Any] = [
                            "name": name,
                             "email": email,
                             "userID": Auth.auth().currentUser?.uid,
                            "imageUrl" : url //?? self.userImage
                        ]
                        //  print(updateDict["imageUrl"])
                        self.sharedRef.database.collection("Users").document(uid!).setData(dict, completion: { (error) in
                            if error == nil {
                                //self.uploadImageOnFirebase()
                                
                           self.performSegue(withIdentifier: "toTabBarFromSignUp", sender: nil)
                                
                            }else
                            {
                                print(error?.localizedDescription)
                            }
                        })
                    }
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

}
