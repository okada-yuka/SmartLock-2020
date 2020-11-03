//
//  LoginViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/03.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self

        if Auth.auth().currentUser != nil{
            print("ログイン中")
        }else{
            print("ログアウト")
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }

    
    @IBAction func loginBtn(_ sender: Any) {
        //インディケータを回す
        indicator.isHidden = false
        indicator.startAnimating()
        
        print(usernameTextField.text)
        print(passwordTextField.text)
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    //タッチしたらキーボードを閉じる
    //画面のどこでも押したらキーボードを閉じるてことで良いの？
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //編集を終了する
        view.endEditing(true)
    }
    //returnキーを押してキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //閉じるってこと？
        //Boolを変える（デフォルトはtrueらしい）
        textField.resignFirstResponder()
    }
    
}

