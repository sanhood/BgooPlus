//
//  Setting.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/27/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import SQLite
class Setting: UIViewController {
    
    @IBOutlet weak var visibility : UIButton!
    @IBOutlet weak var activation : UIButton!
    @IBOutlet weak var other: UIButton!
    @IBOutlet weak var scorll:UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        visibility.layer.cornerRadius = 5
        activation.layer.cornerRadius = 5
        other.layer.cornerRadius = 5
        visibility.layer.masksToBounds = true
        activation.layer.masksToBounds = true
        other.layer.masksToBounds = true
        
        
//        do{
//         //   try changingDB()
//            try check()
//        }catch{print("exp")}
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if screenSize.height >= 736.0 {
            scorll.contentSize.height -= 220
        }else if screenSize.height > 480.0 && screenSize.height < 736.0{
            scorll.contentSize.height -= 85
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        Uplayer.play()
    }
    
    @IBAction func toTree(_ sender: UIButton!){
       // performSegue(withIdentifier: "toTree", sender: nil)
        if let A = UserDefaults.standard.value(forKey: "AState") as? Bool{
            if A || (preActive=="yes"){
               performSegue(withIdentifier: "toTree", sender: nil)
            }else{
                let message  = "در حال حاضر این نسخه دمو میباشد. برای استفاده از قابلیت مخفی سازی بخش ها٬اقدام به فعال سازی اپلیکیشن فرمایید."
                let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
                alert.addAction(ok)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
//    func changingDB() throws{
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let fullPath = paths[0] as NSString
//        let path = fullPath.appendingPathComponent("Begoo.db")
//        let db = try Connection(path)
//        let tab = try db.prepare(table)
//        
//        let alice = table.filter(id_gr1 == 1) //alice is table of all rows that which have id_gr1=1
//        try db.transaction {
//            try db.run(alice.update(vis3<-Int64(0)))
//        }
//        
//    }
//    func check() throws{
//        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let fullPath = paths[0] as NSString
//        let path = fullPath.appendingPathComponent("Begoo.db")
//        let db = try Connection(path, readonly: true)
//        for item in try db.prepare(table){
//            if(item[id_gr1]==1){
//                print(item[vis3])
//            }
//        }
//        
//    }
}
