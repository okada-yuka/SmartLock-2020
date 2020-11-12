//
//  LockViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/04.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import SwiftyJSON

class LockViewController: UIViewController {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var btnLock: UIButton!
    let darkBlue = UIColor(red: 68, green: 111, blue: 128, alpha: 1.0)
    //その時の鍵の状態得る必要があるくない？
    var lockFlag = false
    var defaultStore : Firestore!

    var ref:DatabaseReference!
    let db = Firestore.firestore()
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    var name = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        print("LockViewに入りました")
        
    
        name = appDelegate.name
        nameLab.text = "こんにちは\n"+name+"さん"
        
        defaultStore = Firestore.firestore()

        
        let ref1 = defaultStore.collection("key").document("state")
        ref1.getDocument{ (document, error) in
            if let document = document {
                let state = document.data()?["state"] as! Bool
                self.lockFlag = state
                print(state)
            }else{
                print("Document does not exist")
            }
        }

        

//        //スワイプで前の画面に戻る　できない
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //UITabBar.appearance().barTintColor = darkBlue
        // 背景の透過
        UITabBar.appearance().backgroundImage = UIImage()
        // 境界線の透過
        //UITabBar.appearance().shadowImage = UIImage()
        // 画像と文字の選択時の色を指定（未選択字の色はデフォルトのまま）
        UITabBar.appearance().tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        // タブバーアイコン非選択時の色を変更（iOS 10で利用可能）
        let lightGray = #colorLiteral(red: 0.5433310023, green: 0.5733264594, blue: 0.5487672979, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = lightGray


        
    }

        
    @IBAction func dbBtn(_ sender: Any) {
        defaultStore = Firestore.firestore()
        
        //TimeStampを取得
        let dt = Date()
        let dateFormatter = DateFormatter()
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        print(dateFormatter.string(from: dt))
        
        var operate = ""
        var status = false //部屋にいるか（true: いる，false: いない）
        if self.lockFlag == true{//鍵がかかっており，開けた
            operate = "in"
            status = true
        }else{
            operate = "out"
            status = false
        }
        let ref_key = defaultStore.collection("key")
        ref_key.document("state").setData(["state": false])
        let ref_members = defaultStore.collection("members")
        ref_members.document(name).setData(["name": name, "total-time": 245, "status": true])
        let ref_access = defaultStore.collection("access")
        ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": self.name, "operate": operate])

        
    }
    @IBAction func lockBtn(_ sender: Any) {
        let url = NSURL(string: "https://y2fajblsjk.execute-api.ap-northeast-1.amazonaws.com/api/")
        if UIApplication.shared.canOpenURL(url! as URL){
            //UIApplication.shared.openURL(url! as URL)
        }
        //TimeStampを取得
        let dt = Date()
        let dateFormatter = DateFormatter()
        
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        print(dateFormatter.string(from: dt))
        
        if (lockFlag==true){//開錠をする
            btnLock.setTitle("Lock", for: .normal)
            lockFlag = false
            let ref_key = defaultStore.collection("key")
            ref_key.document("state").updateData(["state": false])
            print("key後　true")
            let ref_access = defaultStore.collection("access")
            ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": name, "operate": "open"])
            print("access後　true")
            let ref_members = defaultStore.collection("members")
            print(name)
            ref_members.document(name).updateData(["status": true])
        }else{
            btnLock.setTitle("unLock", for: .normal)
            lockFlag = true
            let ref_key = defaultStore.collection("key")
            ref_key.document("state").setData(["state": true])
            print("key後")
            let ref_access = defaultStore.collection("access")
            ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": name, "operate": "close"])
            print("access後")
            let ref_members = defaultStore.collection("members")
            print(name)
            ref_members.document(name).updateData(["status": false])
        }
        
    }
    
    func setTabBarItem(index: Int, titile: String, image: UIImage, selectedImage: UIImage,  offColor: UIColor, onColor: UIColor) -> Void {
        let tabBarItem = self.tabBarController?.tabBar.items![index]
        tabBarItem!.title = titile
        tabBarItem!.image = image.withRenderingMode(.alwaysOriginal)
        tabBarItem!.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        tabBarItem!.setTitleTextAttributes([ .foregroundColor : offColor], for: .normal)
        tabBarItem!.setTitleTextAttributes([ .foregroundColor : onColor], for: .selected)
    }
    


}
