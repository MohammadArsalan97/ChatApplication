//
//  SignInViewController.swift
//  chatApp
//
//  Created by Mohammad Arsalan on 25/10/2019.
//  Copyright © 2019 Mohammad Arsalan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    
    @IBOutlet weak var userImageView: CustomImageView!
    @IBOutlet weak var emailTextField: CustomTextField!
    
    @IBOutlet weak var passwordTextField: CustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.text = "user2@gmail.com"
        passwordTextField.text = "123456"
        //view.backgroundColor = Colors.uiView1
        //view.setGradientBackground(colorOne: Colors.lightGrey, colorTwo: Colors.darkGrey)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        
        if let email = emailTextField.text ,let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email , password: password) { (user, error) in
                if user != nil{
                    self.performSegue(withIdentifier: "toTabBarFromSignIn", sender: nil)
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }else{
                     print((error?.localizedDescription)!)
                    // Alert.showErrorAlert(on: self, message: (error?.localizedDescription)!)
                }
            }
        }
    }
    @IBAction func signUpBtn(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    
 
    
    
}
