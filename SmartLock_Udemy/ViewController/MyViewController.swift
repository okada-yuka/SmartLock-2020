//
//  MyViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/06.
//

import UIKit
import WebKit
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseStorage

class MyViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var iconView: WKWebView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var photoBtn: UIButton!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let imagePicker = UIImagePickerController()
    var select_flag = false
    var username = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
        if let url = URL(string: "https://lh3.googleusercontent.com/-2omX_pajzi0/AAAAAAAAAAI/AAAAAAAAA7A/AMZuucnQxzy-IcYqKiJf85XYVPiT4VsNcg/s96-c/photo.jpg") {  // URL文字列の表記間違いなどで、URL()がnilになる場合があるため、nilにならない場合のみ以下のload()が実行されるようにしている
            self.iconView.load(URLRequest(url: url))
        }
        nameLab.text = appDelegate.name
        username = appDelegate.name
    }
    
    @IBAction func photoBtn(_ sender: Any) {
        if select_flag == false{
            photoBtn.setTitle("写真を選ぶ", for: .normal)
            imagePicker.allowsEditing = true //画像の切り抜きが出来るようになります。
            imagePicker.sourceType = .photoLibrary //画像ライブラリを呼び出します
            present(imagePicker, animated: true, completion: nil)
            photoBtn.setTitle("アップロード", for: .normal)
            select_flag = true
        }else{
            upload()
            photoBtn.setTitle("写真を選ぶ", for: .normal)
            select_flag = false
        }
    }
    
    
    
    fileprivate func upload() {
//        //Storageの参照（"Item"という名前で保存）
//        let storageRef = Storage.storage().reference(forURL: "gs://smartlock-kc214.appspot.com").child(appDelegate.name)
//        //画像
//        let date = NSDate()
//        let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
//        let image = UIImage(named: "\(currentTimeStampInSecond).jpg")
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//        if let uploadData = self.imageView.image?.jpegData(compressionQuality: 0.9) {
//            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
//                if error != nil {
//                    print("error: \(error?.localizedDescription)")
//                }
//                storageRef.downloadURL(completion: { (url, error) in
//                    if error != nil {
//                        print("error: \(error?.localizedDescription)")
//                    }
//                    print("url: \(url?.absoluteString)")
//                })
//            }
//        }
        
//            let date = NSDate()
//            let currentTimeStampInSecond = UInt64(floor(date.timeIntervalSince1970 * 1000))
        print(appDelegate.name)
        let storageRef = Storage.storage().reference().child("profile").child("\(self.username).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        if let uploadData = self.imageView.image?.jpegData(compressionQuality: 0.9) {
            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
                if error != nil {
                    print("error: \(error?.localizedDescription)")
                }
                storageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("error: \(error?.localizedDescription)")
                    }
                    print("url: \(url?.absoluteString)")
                })
            }
        }
    }
    
    
    @IBAction func logoutBtn(_ sender: Any) {
        print("ログアウトします")
        //ログイン済みの場合
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        print("ログインしてください")
        
        HomeViewController().loginFlag = false
        appDelegate.name = ""
        appDelegate.email = ""
        appDelegate.id = ""
        //appDelegate.photoURL = ""
        print("name:"+appDelegate.name)
    }
    
}

extension MyViewController {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
