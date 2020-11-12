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

    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var loginFlag = true
    let blue = #colorLiteral(red: 0.4274509804, green: 0.5215686275, blue: 0.6784313725, alpha: 1)
    let pink = #colorLiteral(red: 0.7803921569, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    let gray = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)

    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextBtn.isEnabled = false
        nextBtn.layer.cornerRadius = 4.0
        
        let image = UIImage(named: "gLogin")
        self.loginBtn.setImage(image, for: .normal)
        
        indicator.isHidden = true

        nextBtn.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.4299550514)
        //ボタンのborderを指定（なぜか反映されない）
        nextBtn.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        //appDelegate.idは空だけどAuth.auth().currentUser?.uidは前のが残っている
        //ログアウト実装時にどうするか検討
        if loginCheck() == false{
            let image = UIImage(named: "gLogin")
            self.loginBtn.setImage(image, for: .normal)
            //loginBtn.setTitle("ログイン", for: .normal)
            loginFlag = false
        }

    }
    
    func loginCheck() -> Bool{
        print("loginCheck")
        if appDelegate.id == ""{
            return false
        }else{
            return true
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
    
    @IBAction func nextBtn(_ sender: Any) {
        //TabBarなのでlockVCではなく，TabViewControllerに遷移（storyboardで記述した）
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        
        print("入った")
        indicator.isHidden = false
        indicator.isAnimating
        
        //押せるようにする
        nextBtn.isEnabled = true

        nextBtn.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        //文字の色を指定
        nextBtn.setTitleColor(#colorLiteral(red: 0.4274509804, green: 0.5215686275, blue: 0.6784313725, alpha: 1), for: .normal)

        let firebaseAuth = Auth.auth()
        //Googleのログインメニューを表示する
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
        //7秒でインディケータを消すようにしている．．無理やり
        Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(HomeViewController.stopIndicator), userInfo: nil, repeats: false)
        
        loginFlag = true
  
    }

}
