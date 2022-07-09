//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Umut Can on 5.07.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signInClicked(_ sender: Any) {
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { result, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
            
        }else{
            self.makeAlert(titleInput: "Error", messageInput: "Email/Username/Password Missing?")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        if emailText.text != "" && usernameText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authData, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    
                    let firestoreDatabase = Firestore.firestore()
                    
                    let firestoreData = ["email": self.emailText.text!, "username": self.usernameText.text!] as [String:Any]
                    firestoreDatabase.collection("Users").addDocument(data: firestoreData)
                    
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            self.makeAlert(titleInput: "Error", messageInput: "Email/Username/Password Missing?")
        }
    }
    
    func makeAlert(titleInput: String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

