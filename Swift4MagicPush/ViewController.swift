//
//  ViewController.swift
//  Swift4MagicPush
//
//  Created by 神崎泰旗 on 2018/10/15.
//  Copyright © 2018年 taiki. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var honbunTextField: UITextField!
    
    let timerNotificationIdentifier = "id1"
    
    var resultString = ""
    var ketugouString = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         nameTextField.delegate = self
        honbunTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //名前と本文に記入された文字をつなげる
        resultString = nameTextField.text! + ketugouString + honbunTextField.text!
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
        
        
        
    }
    
    func startPush(){
        
        //5秒後にプッシュ通知を飛ばす
        //通知を飛ばしていいかの許可
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            
            if(settings.authorizationStatus == .authorized){
                
                //知らせる
                self.push()
            }else{
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .badge, .alert], completionHandler: {(granted, error)in
                    
                    if let error = error{
                        print(error)
                        
                    }else{
                        
                        if(granted){
                            
                            self.push()
                        }
                    }
                    
                })
            }
        }
        //
        
    }
    
    func push(){
        
        //textFieldの中にある文字をセットする
        
        let content = UNMutableNotificationContent()
        content.title = nameTextField.text!
        content.subtitle = honbunTextField.text!
        
        let TimerIconURL = Bundle.main.url(forResource: "sunrise", withExtension: "jpg")
        
        let attach = try! UNNotificationAttachment(identifier: timerNotificationIdentifier, url: TimerIconURL!, options: nil)
        
        content.attachments.append(attach)
        
        //5秒後に送信する
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
        let notificationRequest = UNNotificationRequest(identifier: timerNotificationIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            
            //エラー処理
            if let error = error{
            print(error)
            }else{
                
                print("配信されました")
            }
            
            
        }
        
        
        
    }
    

    @IBAction func tap(_ sender: Any) {
        startPush()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

