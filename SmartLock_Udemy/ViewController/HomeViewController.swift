//
//  HomeViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/03.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class HomeViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        //appDelegate.idは空だけどAuth.auth().currentUser?.uidは前のが残っている
        //ログアウト実装時にどうするか検討
        if appDelegate.id == ""{
            print("ログインしてください")
        }else{
            print("ログイン済みです")
        }
        
        
//        print(appDelegate.count)
//        print(appDelegate.id)
//        print(appDelegate.email)
//        print(appDelegate.photoURL)
//        print(appDelegate.displayName)
        

    }
    
    @IBAction func nextBtn(_ sender: Any) {
        
        print("入った")
        
//        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        print(appDelegate.name)
//        print(appDelegate.email)
        
//        print(Auth.auth().currentUser?.photoURL)
        //Googleのログインメニューを表示する
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        print(Auth.auth().currentUser?.uid)
        
//        //ログイン処理
//        //FirebaseAuthに持っていく
//        Auth.auth().signIn(with: credential!) { (result, error) in
//            if let error = error{
//                return
//            }
//            print("サインイン")
//        }
        
    }

}
