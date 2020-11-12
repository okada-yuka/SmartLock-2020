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

class MyViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {


    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let imagePicker = UIImagePickerController()
    var select_flag = false
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        self.name = appDelegate.name
        nameLab.text = name
        let storageref = Storage.storage().reference(forURL: "gs://smartlock-kc214.appspot.com/images/\(name).jpg")
        //画像をセット
        self.profileView.sd_setImage(with: storageref)
    }
    
    @IBAction func photoBtn(_ sender: Any) {
        if select_flag == false{
            photoSelect()
        }
    }
    @IBAction func selectBtn(_ sender: Any) {
        if select_flag == false{
            photoSelect()
        }else{
            upload()
        }
    }
    
    fileprivate func photoSelect(){
        selectBtn.setTitle("写真を選ぶ", for: .normal)
        imagePicker.allowsEditing = true //画像の切り抜きが出来るようになります。
        imagePicker.sourceType = .photoLibrary //画像ライブラリを呼び出します
        present(imagePicker, animated: true, completion: nil)
        selectBtn.setTitle("アップロード", for: .normal)
        select_flag = true
    }
    
    fileprivate func upload() {
        let storageRef = Storage.storage().reference(forURL: "gs://smartlock-kc214.appspot.com/images/\(self.name).jpg")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        if let uploadData = self.imageView.image?.jpegData(compressionQuality: 0.9) {
            storageRef.putData(uploadData, metadata: metaData) { (metadata , error) in
                if error != nil {
                    print("error: \(error?.localizedDescription)")
                }
                storageRef.downloadURL(completion: { (url, error) in
                })
            }
        }
        selectBtn.setTitle("写真を選ぶ", for: .normal)
        select_flag = false
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
