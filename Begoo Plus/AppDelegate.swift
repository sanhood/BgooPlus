//
//  AppDelegate.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/26/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        
        let bundlePath = Bundle.main.path(forResource: "Begoo", ofType: ".db")
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let fileManager = FileManager.default
        let fullDestPath = URL(fileURLWithPath: destPath).appendingPathComponent("BegooPlus.db")
        if fileManager.fileExists(atPath: fullDestPath.path){
           // print("Database file is exist")
           // print(fileManager.fileExists(atPath: bundlePath!))
        }else{
            do{
                try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPath.path)
               // print(fullDestPath)
            }catch{
                print("\n",error)
            }
        }
        
        UserDefaults.standard.setValue("pro", forKey: "lvlishide")
        if UserDefaults.standard.value(forKey: "FirstConnection") == nil {
            UserDefaults.standard.setValue(false, forKey: "FirstConnection")
        }
        if UserDefaults.standard.value(forKey: "preActive") == nil {
            UserDefaults.standard.setValue("yes", forKey: "preActive")
        }
        if UserDefaults.standard.value(forKey: "expireDate") == nil {
            let calendar = Calendar.current
            let expireDate = calendar.date(byAdding: .day, value: 7, to: Date())!
            UserDefaults.standard.setValue(expireDate, forKey: "expireDate")
        }
        
        if let Qcount = UserDefaults.standard.value(forKey: "Qcount") as? Int {
            QuestionCount = Qcount
        }
        if let countforFree = UserDefaults.standard.value(forKey: "countforfree") as? Int {
            countforfree = countforFree
        }
        if let Rectime = UserDefaults.standard.value(forKey: "RecTime") as? Double {
            RecTime = Rectime
        }
        if let result =  UserDefaults.standard.value(forKey: "Results") as? [[String:Any]] {
            Results = result
        }
        if UserDefaults.standard.value(forKey: "AState") == nil {
            UserDefaults.standard.setValue(false, forKey: "AState")
        }
        let path: String? = Bundle.main.path(forResource: "click", ofType: "wav")
        let url = URL(fileURLWithPath: path!)
        do {
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try? AVAudioSession.sharedInstance().setActive(true)
            
            Uplayer = try AVAudioPlayer(contentsOf: url)
        }catch{print("exp")}
        
        
        
        
        Alamofire.request("http://axaan.ir/begoo/info?id=314").responseJSON {
            response in
            
            switch response.result {
            case .failure(_) : break
                
            case .success(_) :
                if let info = (response.result.value as? NSDictionary) {
                    if info["ver_ios"] as! String != iOS_VERSION {
                        UserDefaults.standard.setValue(true, forKey: "FirstConnection")
                        let vc = self.getTopController()
                        let alert = UIAlertController(title: "توجه", message: "ورژن جدید برنامه منتشر شده است. لطفا از طریق اپ استور اقدام به بروز رسانی نمایید", preferredStyle: .alert)
                        let action = UIAlertAction(title: "باشه", style: .default, handler: nil)
                        
                        alert.addAction(action)
                        
                        vc?.present(alert, animated: true, completion: nil)
                    }
                    if (info["ios"] as! String) == "yes" {
                        UserDefaults.standard.setValue("yes", forKey: "preActive")
                        preActive = "yes"
                    }else if (info["ios"] as! String) == "no"{
                        UserDefaults.standard.setValue("no", forKey: "preActive")
                        preActive = "no"
                    }else {
                        UserDefaults.standard.setValue("block", forKey: "preActive")
                        preActive = "block"
                    }
                }
            }
        }

        checkExpired()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController is ActivationVC {
                (topController as! ActivationVC).back()
            }
            // topController should now be your topmost view controller
        }
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        
        
        if (UserDefaults.standard.bool(forKey: "reset_preference")) {
             UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            TreeVC.proDeleted = []
            TreeVC.fundDeleted = []
            UserDefaults.standard.set(false, forKey: "reset_preference")
            UserDefaults.standard.synchronize()
            
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                if topController is TreeVC {
                    //(topController as! TreeVC).viewDidLoad()
                    (topController as! TreeVC).viewDidAppear(true)
                    (topController as! TreeVC).tableView.reloadData()
                }
                
                // topController should now be your topmost view controller
            }
        }
        
        
    }
    
    func getTopController () -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController

            // topController should now be your topmost view controller
        }
        
        return nil

    }

    func applicationWillTerminate(_ application: UIApplication) {
//        if let inTimer = UserDefaults.standard.value(forKey: "inTimer") as? Bool {
//            if(UserDefaults.standard.value(forKey: "exTime") == nil && inTimer){
//                let date = Date()
//                let calendar = Calendar.current
//                let hour = Int(calendar.component(.hour, from: date))
//                let minutes = Int(calendar.component(.minute, from: date))
//                let seconds = Int(calendar.component(.second, from: date))
//                UserDefaults.standard.setValue(["s":seconds,"m":minutes,"h":hour], forKey: "exTime")
//            }
//
//        }
    }
    
    
    func userDefaultsChanged (notification : Notification) {
       // print("changed")
    }
    func checkExpired(){
        if let expireDate = UserDefaults.standard.value(forKey: "expireDate") as? Date {
            let today = Date()
            print(expireDate)
            if today > expireDate {
                preActive = "block"
            }
        }
    }
}

