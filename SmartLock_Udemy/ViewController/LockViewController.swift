//
//  LockViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/04.
//

import UIKit

class LockViewController: UIViewController {

    @IBOutlet weak var nameLab: UILabel!
    @IBOutlet weak var btnLock: UIButton!
    let darkBlue = UIColor(red: 68, green: 111, blue: 128, alpha: 1.0)
    //その時の鍵の状態得る必要があるくない？
    var lockFlag = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = false
        //self.navigationController?.navigationBar.isHidden = false
        //navigationController?.setNavigationBarHidden(false, animated: true)
        print("LockViewに入りました")
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        var name = appDelegate.name
        nameLab.text = "こんにちは\n"+name+"さん"
        
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

    @IBAction func lockBtn(_ sender: Any) {
        let url = NSURL(string: "https://y2fajblsjk.execute-api.ap-northeast-1.amazonaws.com/api/")
        if UIApplication.shared.canOpenURL(url! as URL){
            //UIApplication.shared.openURL(url! as URL)
        }
        if (lockFlag==true){//開錠をする
            btnLock.setTitle("Lock", for: .normal)
            lockFlag = false
        }else{
            btnLock.setTitle("unLock", for: .normal)
            lockFlag = true
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
