//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Umut Can on 5.07.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import SDWebImage

class FeedVC: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var snapArray = [Snap]()
    
    let firestore = Firestore.firestore()
    var chosedSnap : Snap?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getUser()
        getSnaps()
        
        
    }
    func getUser(){
        firestore.collection("Users").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil{
                //Alert
            }else{
                if snapshot != nil && snapshot?.isEmpty == false {
                    for document in snapshot!.documents{
                        if let username = document.get("username") as? String{
                            user.userInfo.username = username
                            user.userInfo.email = Auth.auth().currentUser!.email!
                        }
                    }
                }
            }
        }
        
    }
    
    func getSnaps(){
        firestore.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                //Alert
            }else{
                if snapshot != nil && snapshot?.isEmpty == false{
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents{
                        let documentId = document.documentID
                        
                        if let imageUrlArray = document.get("imageUrlArray") as? [String],
                           let username = document.get("snapOwner") as? String,
                           let date = document.get("date") as? Timestamp{
                            
                            // Resimin yüklendiği zamanı şuandaki zamandan çıkarttık ve 24 saati geçtiyse firestore'dan sildik.
                            if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                if difference >= 24{
                                    self.firestore.collection("Snaps").document(documentId).delete { error in
                                        
                                    }
                                }else{
                                    let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                    self.snapArray.append(snap)
                                }
                            }
                            
                            
                            
                    }
                }
                
            }
                self.tableView.reloadData()
        }
        
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell") as! FeedCell
        print("SNAP ARRAY \(snapArray)")
        cell.usernameField.text = snapArray[indexPath.row].username
        cell.ImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosedSnap = snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC"{
            
            let segueDestination = segue.destination as! SnapVC
            segueDestination.selectedSnap = chosedSnap
        }
    }
    
}
