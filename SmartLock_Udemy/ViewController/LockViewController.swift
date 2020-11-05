//
//  LockViewController.swift
//  SmartLock_Udemy
//
//  Created by Yuka Okada on 2020/11/04.
//

import UIKit

class LockViewController: UIViewController {

    @IBOutlet weak var nameLab: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LockViewに入りました")
        
        var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
        var name = appDelegate.name
        nameLab.text = name
        
//        //スワイプで前の画面に戻る　できない
//        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
