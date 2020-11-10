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

    @IBOutlet weak var iconWebView: UIWebView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var loginFlag = true
    let d_blue = UIColor(red: 58, green: 98, blue: 157, alpha: 1.0)
    let l_blue = UIColor(red: 101, green: 128, blue: 164, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        
        //押せないようにする（色を薄くしておく）
        //nextBtn.backgroundColor = l_blue
        nextBtn.isEnabled = false
        
        let image = UIImage(named: "gLogin")
        self.loginBtn.setImage(image, for: .normal)
        
        indicator.isHidden = true
        
        //appDelegate.idは空だけどAuth.auth().currentUser?.uidは前のが残っている
        //ログアウト実装時にどうするか検討
        if appDelegate.id == ""{
            print("ログインしてください")
            let image = UIImage(named: "gLogin")
            self.loginBtn.setImage(image, for: .normal)
            //loginBtn.setTitle("ログイン", for: .normal)
            loginFlag = false
        }else{
            print("ログイン済みです")
//            let image = UIImage(named: "logout")
//            self.loginBtn.setImage(image, for: .normal)
            //loginBtn.setTitle("ログアウト", for: .normal)
            //KeyViewに遷移する
        }

    }
    
    func loginCheck() {
        print("loginCheck")
        //グローバルにしたら良さそう
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        if appDelegate.id == ""{
            print("ログインできてへん")
        }else{
            print("ログインでけた")
            //これで画面遷移できるはずができない．．とりあえずボタンでの遷移
            //performSegue(withIdentifier: "login", sender: nil)
                    
        }


        
        
    }

    func movingIndicator() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    @objc func stopIndicator() {
        print("indicatorとめます")
        indicator.isHidden = true
        indicator.stopAnimating()
    }
    func gotoKey(){
        print("gotoKeyが呼ばれた")
        
        let lockVC = self.storyboard?.instantiateViewController(withIdentifier: "lockVC") as! LockViewController
        self.present(lockVC, animated: true, completion: nil)
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        //TabBarなのでlockVCではなく，TabViewControllerに遷移（storyboardで記述した）
        //gotoKey()
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        print("入った")
        indicator.isHidden = false
        indicator.isAnimating
        
        //押せるようにする
        nextBtn.isEnabled = true
        nextBtn.backgroundColor = #colorLiteral(red: 0.2291080508, green: 0.3835181924, blue: 0.6173064721, alpha: 1)

        let firebaseAuth = Auth.auth()
        //Googleのログインメニューを表示する
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        //7秒でインディケータを消すようにしている．．無理やり
        Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(HomeViewController.stopIndicator), userInfo: nil, repeats: false)
        
        loginFlag = true
        //場所変えたい
//        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            let image = UIImage(named: "logout")
//            self.loginBtn.setImage(image, for: .normal)
        //loginBtn.setTitle("ログアウト", for: .normal)
        //self.loginBtn.setTitleColor(UIColor.red, for: .normal)
        //名前とアイコンを表示してKeyViewに遷移する
        //nameLab.text = appDelegate.name

            
        

        

        
    }

}
