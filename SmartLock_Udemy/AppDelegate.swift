//
//  AppDelegate.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/01.
//

import UIKit
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    let count = 0
    var id = ""
    var email = ""
    var photoURL = ""
    var name = ""
    
    var window: UIWindow?
    
    //mainVCに画面遷移するため　方法2
//    var CurrentVC = UIApplication.shared.keyWindow?.rootViewController

//    var HomeViewController: ViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        return true
    }


    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
//    //GIDSignIn インスタンスの handleURL メソッドを呼び出す
//    //認証プロセスの最後にアプリが受け取る URL が正しく処理される
//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
//      -> Bool {
//      return GIDSignIn.sharedInstance().handle(url)
//    }
//
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
      // ...
        if let error = error {
            // ...
            return
            
        }

        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        // ...
        
        //FirebaseAuthに持っていく
        Auth.auth().signIn(with: credential) { (result, error) in
            if error == nil{
                print("サインイン")
            }else{
                print("エラーあり")
                print(error)
                return
            }
            
            
            
            let user = Auth.auth().currentUser
            if let user = user {
                self.id = user.uid
                self.name = user.displayName ?? "[DispayName]"
                self.email = user.email ?? "[EMail]"
        //                self.photoURL = user.photoURL
                var multiFactorString = "MultiFactor: "
                for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                }
            }
            
            print(self.name)
            //ログイン後にログインできたかを確認
            HomeViewController().loginCheck()
            //HomeViewController().gotoKey()
        }

        
    }
}

