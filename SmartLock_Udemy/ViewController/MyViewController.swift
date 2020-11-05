//
//  MyViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/06.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class MyViewController: UIViewController {

    @IBOutlet weak var logoutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func logoutBtn(_ sender: Any) {
        print("ログアウトします")
        //ログイン済みの場合
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        print("ログインしてください")
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        HomeViewController().loginFlag = false
        appDelegate.name = ""
        appDelegate.email = ""
        appDelegate.id = ""
        appDelegate.photoURL = ""
        print("name:"+appDelegate.name)
    }


}
