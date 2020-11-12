//
//  RoomViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/08.
//

import UIKit
import WebKit
import FirebaseDatabase
import FirebaseFirestore
import SwiftyJSON
import FirebaseStorage
import SDWebImage
import FirebaseUI

class RoomViewController: UIViewController {

    var defaultStore : Firestore!
    
    @IBOutlet weak var recordLab: UILabel!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon3: UIImageView!
    @IBOutlet weak var icon4: UIImageView!
    @IBOutlet weak var icon5: UIImageView!
    @IBOutlet weak var icon6: UIImageView!
    @IBOutlet weak var icon7: UIImageView!
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var iconArray: [UIImageView] = []
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name = appDelegate.name
        defaultStore = Firestore.firestore()
        
        //キャッシュを消す
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }

    
    // 完全に全ての読み込みが完了時に実行
    override func viewDidAppear(_ animated: Bool) {

        //キャッシュを消す
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
        
        iconArray = [icon1, icon2, icon3, icon4, icon5, icon6, icon7]
        //在室状況により表示を変える（場所を変えないと最初の読み込み時にしか反映されない）
        defaultStore.collection("members").getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        if document.data()["status"]as! Bool == true{
                            self.iconArray[document.data()["iconNo"]as! Int - 1].isHidden = false
                            let ref_image = Storage.storage().reference(forURL: "gs://smartlock-kc214.appspot.com/images/\(document.data()["name"]as! String).jpg")
                            //画像をセット
                            self.iconArray[document.data()["iconNo"]as! Int - 1].sd_setImage(with: ref_image)
                        }else{
                            self.iconArray[document.data()["iconNo"]as! Int - 1].isHidden = true
                        }
                    }
                }
        }
            
        
    }
    
    @IBAction func reloadBtn(_ sender: Any) {
        let ref_status = defaultStore.collection("members").whereField("status", isEqualTo: true).getDocuments() { (querySnapshot, err) in
            var members = ""
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    members += ((document.data()["name"]) as! String+"\n")
                }
            }
            self.recordLab.text = members
        }
    }

    func setTabBarItem(index: Int, titile: String, image: UIImage, selectedImage: UIImage,  offColor: UIColor, onColor: UIColor) -> Void {
        let tabBarItem = self.tabBarController?.tabBar.items![index]
        tabBarItem!.title = titile
        tabBarItem!.image = image.withRenderingMode(.alwaysOriginal)
        tabBarItem!.selectedImage = selectedImage.withRenderingMode(.alwaysOriginal)
        tabBarItem!.setTitleTextAttributes([ .foregroundColor : offColor], for: .normal)
        tabBarItem!.setTitleTextAttributes([ .foregroundColor : onColor], for: .selected)
        //UITabBar.appearance().barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
}
