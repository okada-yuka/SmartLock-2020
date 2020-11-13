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
import SDWebImage
import FirebaseUI

class MyViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {


    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var statusLab: UILabel!
    @IBOutlet weak var totalTimeLab: UILabel!
    
    var defaultStore : Firestore!
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let imagePicker = UIImagePickerController()
    var select_flag = false
    var name = ""
    
    let blue = #colorLiteral(red: 0.4274509804, green: 0.5215686275, blue: 0.6784313725, alpha: 1)
    let pink = #colorLiteral(red: 0.7803921569, green: 0.6117647059, blue: 0.6117647059, alpha: 1)
    let gray = #colorLiteral(red: 0.2705882353, green: 0.2705882353, blue: 0.2705882353, alpha: 1)
    
    //imageをからで宣言する方法がわからん
    var image = UIImage(named: "logo.png")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultStore = Firestore.firestore()
        textField.delegate = self
        imagePicker.delegate = self
        self.name = appDelegate.name
        nameLab.text = name
        let storageref = Storage.storage().reference(forURL: "gs://smartlock-kc214.appspot.com/images/\(name).jpg")
        //画像をセット
        self.profileView.sd_setImage(with: storageref)
        
        logoutBtn.layer.borderColor = #colorLiteral(red: 0.5921034217, green: 0.5921911597, blue: 0.592084229, alpha: 1)
        logoutBtn.layer.cornerRadius = 4.0
        logoutBtn.layer.borderWidth = 2.0

        let ref_state = defaultStore.collection("members").document(name)
        ref_state.getDocument{ (document, error) in
            if let document = document {
                let state = document.data()?["status"] as! Bool
                if state == true{
                    self.statusLab.text = "在室中"
                }else{
                    self.statusLab.text = "退室中"
                }
            }else{
                print("Document does not exist")
            }
            
            //self.keyLabel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //キャッシュを消す
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()

        //在室状況と累計時間を取得
        let ref_state = defaultStore.collection("members").document(name)
        ref_state.getDocument{ (document, error) in
            if let document = document {
                let state = document.data()?["status"] as! Bool
                if document.data()?["status"]as! Bool == true{//在室中の場合
                    self.statusLab.text = "在室中"
                }else{
                    self.statusLab.text = "退室中"
                }
                self.totalTimeLab.text = "\(String(document.data()?["total-time"]as! Int))時間"
            }else{
                print("Document does not exist")
            }
            
            //self.keyLabel()
        }
        
    }
    
    @IBAction func photoBtn(_ sender: Any) {
        changePhoto()
    }

    
    fileprivate func changePhoto(){
        imagePicker.allowsEditing = true //画像の切り抜きが出来るようになります。
        imagePicker.sourceType = .photoLibrary //画像ライブラリを呼び出します
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        //ログイン済みの場合
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }

        HomeViewController().loginFlag = false
        appDelegate.name = ""
        appDelegate.email = ""
        appDelegate.id = ""
        //appDelegate.photoURL = ""
    }
    
    //画面のどこかにタッチしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //returnキーを押してキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //    fileprivate func photoSelect(){
    //        selectBtn.setTitle("写真を選ぶ", for: .normal)
    //        imagePicker.allowsEditing = true //画像の切り抜きが出来るようになります。
    //        imagePicker.sourceType = .photoLibrary //画像ライブラリを呼び出します
    //        present(imagePicker, animated: true, completion: nil)
    //        selectBtn.setTitle("アップロード", for: .normal)
    //        select_flag = true
    //    }
    //
    //    fileprivate func upload() {
    //        let storageRef = Storage.storage().reference(forURL: "gs://smartlock-kc214.appspot.com/images/\(self.name).jpg")
    //        let metaData = StorageMetadata()
    //        metaData.contentType = "image/jpg"
    //        if let uploadData = self.imageView.image?.jpegData(compressionQuality: 0.9) {
    //            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
    //                if error != nil {
    //                    print("error: \(error?.localizedDescription)")
    //                }
    //                storageRef.downloadURL(completion: { (url, error) in
    //                })
    //            }
    //        }
    //        selectBtn.setTitle("写真を選ぶ", for: .normal)
    //        select_flag = false
    //    }
    
}


extension MyViewController {
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //画像を選択
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            self.image = pickedImage
            print("picked imageを設定")
        }
        
        //選択した画像をupload
        let storageRef = Storage.storage().reference(forURL: "gs://smartlock-kc214.appspot.com/images/\(self.name).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        print("picked imageを変換")
        if let uploadData = self.image?.jpegData(compressionQuality: 0.9) {
            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
                if error != nil {
                    print("error: \(error?.localizedDescription)")
                }
                storageRef.downloadURL(completion: { (url, error) in
                })
            }
        }
        //viewController自身を破棄する
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
