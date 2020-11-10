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
    let db = Firestore.firestore()
    
    @IBOutlet weak var recordLab: UILabel!
    @IBOutlet weak var icon1: UIImageView!
    @IBOutlet weak var icon2: UIImageView!
    @IBOutlet weak var icon6: WKWebView!
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultStore = Firestore.firestore()
//        let ref_key = defaultStore.collection("key")
//        ref_key.document("state").setData(["state": false])
        
        let ref1 = defaultStore.collection("members").document(appDelegate.name)
        ref1.getDocument{ [self] (document, error) in
            if let document = document {
                let status = document.data()?["status"] as! Bool
                print("RoomViewにてStatus")
                print(status)
                
                if status == true{
                    //StorageのURLを参照
                    let storageref = Storage.storage().reference(forURL: "gs://smartlock-kc214.appspot.com").child("profile").child("\(appDelegate.name).jpg")
                    //画像をセット
                    self.icon1.sd_setImage(with: storageref)
                }
                
            }else{
                print("Document does not exist")
            }
        }

        
        if let url = URL(string: "https://lh3.googleusercontent.com/-2omX_pajzi0/AAAAAAAAAAI/AAAAAAAAA7A/AMZuucnQxzy-IcYqKiJf85XYVPiT4VsNcg/s96-c/photo.jpg") {  // URL文字列の表記間違いなどで、URL()がnilになる場合があるため、nilにならない場合のみ以下のload()が実行されるようにしている
            self.icon6.load(URLRequest(url: url))
        }
    }
    
    
    @IBAction func reloadBtn(_ sender: Any) {
        defaultStore = Firestore.firestore()
        let ref1 = defaultStore.collection("members").whereField("status", isEqualTo: true).getDocuments() { (querySnapshot, err) in
            var members = ""
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print(document.data()["name"] as! String)
                    members += ((document.data()["name"]) as! String+"\n")
                }
            }
            self.recordLab.text = members
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
