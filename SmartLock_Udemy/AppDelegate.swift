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
            
            
//            let user = Auth.auth().currentUser
//            print(user.getDisplayName)
            
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
                
                
                print()
                print(self.id)
                print(user.displayName)
                
//                var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                let viewVC = self.storyboard?.instantiateViewController(identifier: "viewVC") as! ViewController
                
                //mainVCに遷移
//                ViewController().getTopMostViewController()
//                ViewController().ChangeVC()
                
                //画面遷移させたい部分に以下の処理を記述
                //　windowを生成
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                //　Storyboardを指定
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                // Viewcontrollerを指定
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LockVC")
//                // rootViewControllerに入れる
//                self.window?.rootViewController = initialViewController
//                // 表示
//                self.window?.makeKeyAndVisible()
                
                //AppDelegateでのLockVCへの画面遷移は断念（HomeViewControllerでする）
            
//                //　windowを生成
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                //　Storyboardを指定
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                //storyboardIDを設定
//                let lockVC = storyboard.instantiateViewController(withIdentifier: "LockVC") as! LockViewController
//    //            let lockVC = self.storyboard?.instantiateInitialViewController()
//                //let lockVC = self.storyboard?.instantiateViewController(identifier: "lockVC") as! ViewController
//                //viewVCに画面遷移する
//                //self.navigationController?.pushViewController(lockVC, animated: true)
//                //self.present(lockVC, animated: true, completion: nil)
//                // rootViewControllerに入れる
//                self.window?.rootViewController = lockVC
//                // 表示
//                self.window?.makeKeyAndVisible()
                
//                //　Storyboardを指定
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                //storyboardIDを設定
//                let lockVC = storyboard.instantiateViewController(identifier: "LockVC")
//                //viewVCに画面遷移する
//                self.pushViewController(lockVC, animated: true)
            
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let initialViewController = storyboard.instantiateViewController(withIdentifier: "LockVC")
            }
        }
        
        
    }

//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//    }
}

