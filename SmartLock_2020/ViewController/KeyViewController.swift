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

class KeyViewController: UIViewController {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var exportBtn: UIButton!
    
    
    
    let darkBlue = UIColor(red: 68, green: 111, blue: 128, alpha: 1.0)
    var lockFlag = false//鍵がかかっている場合true
    var inFlag = false //その人が中にいる場合場合true
    //DBのkey-stateは，鍵がかかっている場合true
    var stateFlag = false//DBのkey-stateがtrueの場合true
    var defaultStore : Firestore!
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var name = ""
    
    let open = UIImage(named: "open")
    let close = UIImage(named: "close")
    let enter = UIImage(named: "enter")
    let exit = UIImage(named: "exit")
    let btn_state = UIControl.State.normal
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
    
        name = appDelegate.name
        nameLab.text = "こんにちは！\n"+name+"さん"
        
        defaultStore = Firestore.firestore()

        reloadBtn.layer.cornerRadius = 4.0
        exportBtn.layer.cornerRadius = 4.0
        
        let ref_state = defaultStore.collection("key").document("state")
        ref_state.getDocument{ (document, error) in
            if let document = document {
                let state = document.data()?["state"] as! Bool
                self.lockFlag = state
                if self.lockFlag == true{
                    self.lockBtn.setImage(self.open, for: self.btn_state)
                }else{
                    self.lockBtn.setImage(self.close, for: self.btn_state)
                }
            }else{
                print("Document does not exist")
            }
            //self.keyLabel()
        }
        
        
        let ref_status = defaultStore.collection("members").document(name)
        ref_status.getDocument{ (document, error) in
            if let document = document {
                if document.data()?["status"] as! Bool == false{
                    self.exitBtn.setImage(self.enter, for: self.btn_state)
                    self.inFlag = false
                }else{
                    self.exitBtn.setImage(self.exit, for: self.btn_state)
                    self.inFlag = true
                }
            }else{
                print("Document does not exist")
            }
        }
        
        defaultStore.collection("access").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {

                        let time = document.data()["time"] as! String
                        let name = document.data()["name"] as! String
                        let operate = document.data()["operate"] as! String
                        self.textView.text = self.textView.text + time + "\n" + name + "が" + operate + "\n"
                            
                    }
                }
        }
        // 編集機能を無効にする.
        textView.isEditable = false
        // 範囲選択を無効にする.
        textView.isSelectable = false

//        textView.layer.position = CGPoint(x: screenSize.width/2, y: screenSize.height/2)

//        self.view.addSubview(textView)
        
        textView.layer.borderColor = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
        textView.layer.borderWidth = 2.0
        textView.layer.cornerRadius = 4.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //UITabBar.appearance().barTintColor = darkBlue
        // 背景の透過
        UITabBar.appearance().backgroundImage = UIImage()
        // 境界線の透過
        //UITabBar.appearance().shadowImage = UIImage()
        // 画像と文字の選択時の色を指定（未選択字の色はデフォルトのまま）
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.4274509804, green: 0.5215686275, blue: 0.6784313725, alpha: 1)
        // タブバーアイコン非選択時の色を変更（iOS 10で利用可能）
        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.6846914741, green: 0.6760138789, blue: 0.7126953319, alpha: 1)
        
//        recordLab.numberOfLines = 0
//        recordLab.sizeToFit()
    }

    @IBAction func reloadBtn(_ sender: Any) {
//        let ref_status = defaultStore.collection("access").document()
//        ref_status.getDocument{ (document, error) in
//
//            if let document = document {
//                let name = document.data()?["name"] as! String
//                let time = document.data()?["time"] as! String
//                let operate = document.data()?["operate"] as! String
//                self.textView.text = self.textView.text! + "\(time)\n\(name)さんが\(operate)\n"
//            }else{
//                print("Document does not exist")
//            }
//        }
        
        //在室状況により表示を変える（場所を変えないと最初の読み込み時にしか反映されない）
        self.textView.text = ""
        defaultStore.collection("access").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {

                        let time = document.data()["time"] as! String
                        let name = document.data()["name"] as! String
                        let operate = document.data()["operate"] as! String
                        self.textView.text = self.textView.text + time + "\n" + name + "が" + operate + "\n"
                            
                    }
                }
        }
    }
    
    @IBAction func exitBtn(_ sender: Any) {
        //TimeStampを取得
        let dt = Date()
        let dateFormatter = DateFormatter()
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        
        if (inFlag==true){//中にいて帰る時
            exitBtn.setImage(enter, for: btn_state)
            let ref_access = defaultStore.collection("access")
            ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": name, "operate": "exit"])
            let ref_members = defaultStore.collection("members")
            ref_members.document(name).updateData(["status": false])
            inFlag = false
        }else{
            if (lockFlag == true){//鍵がかかっている場合
                let ref_key = defaultStore.collection("key")
                ref_key.document("state").updateData(["state": false])
                lockBtn.setImage(close, for: btn_state)
                let ref_access = defaultStore.collection("access")
                ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": name, "operate": "open"])
            }else{
                let ref_access = defaultStore.collection("access")
                ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": name, "operate": "enter"])
            }
            exitBtn.setImage(exit, for: btn_state)
            let ref_members = defaultStore.collection("members")
            ref_members.document(name).updateData(["status": true])
            inFlag = true
        }
        //keyLabel()
        
    }
    
    
    @IBAction func lockBtn(_ sender: Any) {
        //鍵を動かすlambda関数を叩く
//        let url = NSURL(string: "https://***")
//        if UIApplication.shared.canOpenURL(url! as URL){
//            //UIApplication.shared.openURL(url! as URL)
//        }
        //TimeStampを取得
        let dt = Date()
        let dateFormatter = DateFormatter()
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
        
        if (lockFlag==true){//開錠をする
            lockBtn.setImage(close, for: btn_state)
            exitBtn.setImage(exit, for: btn_state)
            lockFlag = false
            let ref_key = defaultStore.collection("key")
            ref_key.document("state").updateData(["state": false])
            let ref_access = defaultStore.collection("access")
            ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": name, "operate": "open"])
            let ref_members = defaultStore.collection("members")
            ref_members.document(name).updateData(["status": true])
//            addRecord(time: dateFormatter.string(from: dt), name: name, operation: "解錠")
//            textView.text = "\(dateFormatter.string(from: dt))\n\(name)さんが解錠\n" + textView.text!
        }else{
            lockBtn.setImage(open, for: btn_state)
            exitBtn.setImage(enter, for: btn_state)
            lockFlag = true
            let ref_key = defaultStore.collection("key")
            ref_key.document("state").setData(["state": true])
            let ref_access = defaultStore.collection("access")
            ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": name, "operate": "close"])
            let ref_members = defaultStore.collection("members")
            ref_members.document(name).updateData(["status": false])
//            addRecord(time: dateFormatter.string(from: dt), name: name, operation: "施錠")
//            textView.text = "\(dateFormatter.string(from: dt))\n\(name)さんが施錠\n" + textView.text!
        }
        
    }
    
    //ここから（改行がうまくできていない？）
//    func addRecord(time: String, name: String, operation: String){
//        recordLab.text = recordLab.text! + "\(time)\n\(name)さんが\(operation)\n"
//        print(recordLab.text)
//    }
    
    func setTabBarItem(index: Int, titile: String, image: UIImage, selectedImage: UIImage,  offColor: UIColor, onColor: UIColor) -> Void {
        let tabBarItem = self.tabBarController?.tabBar.items![index]
        tabBarItem!.title = titile
        tabBarItem!.image = image.withRenderingMode(.alwaysOriginal)
        tabBarItem!.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        tabBarItem!.setTitleTextAttributes([ .foregroundColor : offColor], for: .normal)
        tabBarItem!.setTitleTextAttributes([ .foregroundColor : onColor], for: .selected)
    }
    
    // keyStateは関数にしたかったけど，なぜかうまくデータをとって来れない
    //    func checkKey() -> Bool{
    //        defaultStore = Firestore.firestore()
    //        let ref_state = defaultStore.collection("key").document("state")
    //        ref_state.getDocument{ (document, error) in
    //            if let document = document {
    //                self.stateFlag = document.data()?["state"] as! Bool
    //            }
    //            print("incKey")
    //            print(self.stateFlag)
    //        }
    //        print("out ref")
    //        print(self.stateFlag)
    //        return self.stateFlag
    //    }
    //
    //    func keyLabel(){
    //        if checkKey() == false{ //なんでtrueとfalseが逆になっているのかはよくわからん
    ////            print("lab-true")
    ////            print(checkKey())
    ////            print("鍵がかかっています")
    //            self.keyState.text = "鍵がかかっています"
    //        }else{
    ////            print("lab-false")
    ////            print(checkKey())
    ////            print("開いてます")
    //            self.keyState.text = "開いています"
    //        }
    //    }
    
    //    @IBAction func dbBtn(_ sender: Any) {
    //        defaultStore = Firestore.firestore()
    //
    //        //TimeStampを取得
    //        let dt = Date()
    //        let dateFormatter = DateFormatter()
    //        // DateFormatter を使用して書式とロケールを指定する
    //        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMdHms", options: 0, locale: Locale(identifier: "ja_JP"))
    //        print(dateFormatter.string(from: dt))
    //
    //        var operate = ""
    //        var status = false //部屋にいるか（true: いる，false: いない）
    //        if self.lockFlag == true{//鍵がかかっており，開けた
    //            operate = "in"
    //            status = true
    //        }else{
    //            operate = "out"
    //            status = false
    //        }
    //        let ref_key = defaultStore.collection("key")
    //        ref_key.document("state").setData(["state": false])
    //        let ref_members = defaultStore.collection("members")
    //        ref_members.document(name).setData(["name": name, "total-time": 245, "status": true])
    //        let ref_access = defaultStore.collection("access")
    //        ref_access.document(dateFormatter.string(from: dt)).setData(["time": dateFormatter.string(from: dt), "name": self.name, "operate": operate])
    //
    //    }


}
