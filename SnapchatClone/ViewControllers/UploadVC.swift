//
//  UploadVC.swift
//  SnapchatClone
//
//  Created by Umut Can on 5.07.2022.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import FirebaseCore

class UploadVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func makeAlert(titleInput: String, messageInput:String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

    @IBAction func uploadClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let uuid = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data) { metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    imageReference.downloadURL { url, error in
                        if error != nil{
                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                        }else{
                            
                            let imageURL = url?.absoluteString
                            
                            //Firestore
                            
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: user.userInfo.username!).getDocuments { snapshot, error in
                                if error != nil{
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                }else{
                                    if snapshot != nil && snapshot?.isEmpty == false{
                                        for document in snapshot!.documents{
                                            
                                            let ID = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String]{
                                                imageUrlArray.append(imageURL!)
                                                
                                                let newArray = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                
                                                firestore.collection("Snaps").document(ID).setData(newArray, merge: true) { error in
                                                    if error == nil{
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "select")
                                                    }
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }else{
                                        
                                        let snapArray = ["imageUrlArray": [imageURL!] , "snapOwner": user.userInfo.username! , "date": FieldValue.serverTimestamp()] as! [String : Any]
                                        
                                        firestore.collection("Snaps").addDocument(data: snapArray) { error in
                                            if error != nil{
                                                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                            }else{
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageView.image = UIImage(named: "select")
                                            }
                                    
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    
                }
            }
        }
    }
    
}
