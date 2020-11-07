//
//  RoomViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/08.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import SwiftyJSON

class RoomViewController: UIViewController {

    var defaultStore : Firestore!
    let db = Firestore.firestore()
    
    @IBOutlet weak var recordLab: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func reloadBtn(_ sender: Any) {
        defaultStore = Firestore.firestore()
        let ref1 = defaultStore.collection("members").whereField("status", isEqualTo: true).getDocuments() { (querySnapshot, err) in
            var members = ""
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(document.data()["name"] as! String)
                    members += (document.data()["name"] as! String+"\n")
                }
            }
            self.recordLab.text = members
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
