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

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var iconWebView: UIWebView!
    @IBOutlet weak var nextBtn: UIButton!
    var loginFlag = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        //appDelegate.idは空だけどAuth.auth().currentUser?.uidは前のが残っている
        //ログアウト実装時にどうするか検討
        if appDelegate.id == ""{
            print("ログインしてください")
            nextBtn.setTitle("ログイン", for: .normal)
            loginFlag = false
        }else{
            print("ログイン済みです")
            nextBtn.setTitle("ログアウト", for: .normal)
            //KeyViewに遷移する
        }
        
        print("viewDidLoad")
//        print(appDelegate.count)
//        print(appDelegate.id)
//        print(appDelegate.email)
//        print(appDelegate.photoURL)
//        print(appDelegate.displayName)
        

    }
    

    
    @IBAction func nextBtn(_ sender: Any) {
        
        print("入った")
        
        //ログイン前の場合
        if loginFlag == false{
            let firebaseAuth = Auth.auth()
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
            loginFlag = true
            //場所変えたい
            nextBtn.setTitle("ログアウト", for: .normal)
            
            //名前とアイコンを表示してKeyViewに遷移する
            nameLab.text = Auth.auth().currentUser?.displayName
            print(Auth.auth().currentUser?.displayName)
            
            //11/4：ロード終了後など，良いタイミングに変更できそうならする
            //画面遷移
            //storyboardIDを設定
            let lockVC = self.storyboard?.instantiateViewController(withIdentifier: "LockVC") as! LockViewController
//            let lockVC = self.storyboard?.instantiateInitialViewController()
            //let lockVC = self.storyboard?.instantiateViewController(identifier: "lockVC") as! ViewController
            //値を渡す
            lockVC.name = Auth.auth().currentUser?.displayName ?? "[displayName]"
            //viewVCに画面遷移する
            //self.navigationController?.pushViewController(lockVC, animated: true)
            self.present(lockVC, animated: true, completion: nil)
            
        }else{
            print("ログアウトします")
            //ログイン済みの場合
            let firebaseAuth = Auth.auth()
            do {
              try firebaseAuth.signOut()
            } catch let signOutError as NSError {
              print ("Error signing out: %@", signOutError)
            }
            
            //名前とアイコンを空にする
            nameLab.text = ""
            
            nextBtn.setTitle("ログイン", for: .normal)
            print("ログインしてください")
            loginFlag = false
        }
        

        
    }

}
