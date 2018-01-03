//
//  ActivationVC.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/29/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import Alamofire
class ActivationVC: UIViewController {
    var state=""
    @IBOutlet weak var SerialField: UITextField!
    @IBOutlet weak var ActivationBtn: UIButton!
    @IBOutlet weak var DeactivationBtn: UIButton!
    @IBOutlet weak var buy : UIButton!
    @IBOutlet weak var ActivationIcon : UIImageView!
    @IBOutlet weak var BuyIcon : UIImageView!
  //  @IBOutlet weak var contact : UIButton!
    @IBOutlet weak var CountDownLbl: UILabel!
    @IBOutlet weak var contactScrollView : UIScrollView!
    @IBOutlet weak var topCnstraint: NSLayoutConstraint!
    
    
    var urls : NSDictionary?
    
    
    var Sec = 0
    var Min = 0
    var Hour = 1
    var timer : Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        buy.layer.cornerRadius = 5
       // contact.layer.cornerRadius = 5
        ActivationBtn.layer.cornerRadius = 5
        DeactivationBtn.layer.cornerRadius = 5
        ActivationBtn.layer.masksToBounds = true
        DeactivationBtn.layer.masksToBounds = true
        buy.layer.masksToBounds = true
       // contact.layer.masksToBounds = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ActivationVC.dismissKeyboard))
        
        let taptap =  UITapGestureRecognizer(target: self, action: #selector(ActivationVC.dismissDashboard))
        
        view.addGestureRecognizer(tap)
        view.addGestureRecognizer(taptap)
        
        
        
        
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        contactScrollView.contentSize = CGSize(width: 414, height: contactScrollView.frame.height)
        contactScrollView.layer.cornerRadius = 4.0
        
        //print(contactScrollView.frame)
        
        let imageWeb = #imageLiteral(resourceName: "website")
        let imageChannel = #imageLiteral(resourceName: "telegram")
        let imagePhone = #imageLiteral(resourceName: "phone")
        let imageInsta = #imageLiteral(resourceName: "instagram")
        
        let buttonWeb = UIButton(frame: CGRect(x: 25, y: 5, width: contactScrollView.frame.height-10, height: contactScrollView.frame.height-10))
        buttonWeb.setImage(imageWeb, for: UIControlState())
        buttonWeb.tag = 1
        buttonWeb.addTarget(self, action: #selector(scrollViewButtonTapped(_:)), for: .touchUpInside)
        
        let buttonChannel = UIButton(frame: CGRect(x: 121, y: 5, width: contactScrollView.frame.height-10, height: contactScrollView.frame.height-10))
        buttonChannel.setImage(imageChannel, for: UIControlState())
        buttonChannel.tag = 2
        buttonChannel.addTarget(self, action: #selector(scrollViewButtonTapped(_:)), for: .touchUpInside)
        
        
        
        
        let buttonPhone = UIButton(frame: CGRect(x: 217, y: 5, width: contactScrollView.frame.height-10, height: contactScrollView.frame.height-10))
        buttonPhone.setImage(imagePhone, for: UIControlState())
        buttonPhone.tag = 3
        buttonPhone.addTarget(self, action: #selector(scrollViewButtonTapped(_:)), for: .touchUpInside)
        
        
        
        let buttonInsta = UIButton(frame: CGRect(x: 313, y: 5, width: contactScrollView.frame.height-10, height: contactScrollView.frame.height-10))
        buttonInsta.setImage(imageInsta, for: UIControlState())
        buttonInsta.tag = 4
        buttonInsta.addTarget(self, action: #selector(scrollViewButtonTapped(_:)), for: .touchUpInside)
        //contactScrollView.addSubview(buttonWeb)
        
        
        contactScrollView.addSubViews(views: [buttonWeb , buttonChannel , buttonPhone , buttonInsta])
        
        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        buy.titleLabel?.adjustsFontSizeToFitWidth = true
        DeactivationBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        checkThatShit()
        if let serial = UserDefaults.standard.value(forKey: "serial") as? String{
            SerialField.text=serial
        }
        if let state = UserDefaults.standard.value(forKey: "AState") as? Bool {
            if state{
                ActivationBtn.isHidden = true
               // DeactivationBtn.isHidden = false
                SerialField.isUserInteractionEnabled = false

               
            }else{
                DeactivationBtn.isHidden = true
               // ActivationBtn.isHidden = false
                SerialField.isUserInteractionEnabled = true
            }
        }
        if (preActive=="yes") {
            ActivationBtn.isHidden = true
            DeactivationBtn.isHidden = true
            buy.isHidden = true
            BuyIcon.isHidden = true
            ActivationIcon.isHidden = true
            SerialField.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    @IBAction func De_ActivePressed(_ sender: UIButton) {
        if sender.tag==0{     //activation
            
            let message="در صورت انجام عملیات فعال سازی به مدت یک ساعت قادر به غیر فعال کردن آن نیستید\nآیا مایل به ادامه هستید؟"
            let alert = UIAlertController(title: "هشدار", message: message, preferredStyle: .alert)
            let no = UIAlertAction(title: "خیر", style: .default , handler: nil)
            let yes = UIAlertAction(title: "بله", style: .default , handler: { void in
                self.Activation()
            })
            alert.addAction(no)
            alert.addAction(yes)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }else if sender.tag==1{      //deactivation
            
            let message="در صورت انجام عملیات غیر فعال سازی به مدت یک ساعت قادر به فعال سازی نیستید\nآیا مایل به ادامه هستید؟"
            let alert = UIAlertController(title: "هشدار", message: message, preferredStyle: .alert)
            let no = UIAlertAction(title: "خیر", style: .default , handler: nil)
            let yes = UIAlertAction(title: "بله", style: .default , handler: { void in
                self.Deactivation()
            })
            alert.addAction(no)
            alert.addAction(yes)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    func Activation(){
        let id = UIDevice.current.identifierForVendor!.uuidString
        let serial=String(describing: SerialField.text!.convertNumToEnglish())
        //let url = "http://axaan.ir/begoo/active?serial=\(deviceID)&active_code=\(serial)&os=ios"
        //let url = "http://axaan.ir/begoo/active?serial=999999999&active_code=123456&os=ios"
        let url = "http://axaan.ir/begoo/active?serial=\(id)&active_code=\(serial)&os=ios&type=begooplus"
        //let url = "http://axaan.ir/begoo/active?serial=\(id)&active_code=\(serial)"
        Alamofire.request(url).responseJSON{ response in
            switch response.result{
            case .failure(_):
                let message  = "خطا در ارتباط با سرور"
                let alert = UIAlertController(title: "خطا", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
                let settings = UIAlertAction(title: "تنظیمات", style: .default , handler: { void in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                    }
                })
                
                alert.addAction(ok)
                alert.addAction(settings)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            case .success(_):
                if let situation = (response.result.value as? Dictionary<String,String>)?["resoult"]{
                  //  print(situation)
                    if situation == "befor active" {
                        let message = "از این سریال در موبایل دیگری استفاده شده. برای استفاده از این سریال٬آن را در دستگاه های دیگر غیر فعال کرده و مجددا تلاش فرمایید."
                        let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .actionSheet)
                        let ok = UIAlertAction(title: "باشه", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.dismissKeyboard()
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else if situation == "active"{
                        let message = "فعال سازی موفقیت آمیز بود"
                        let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .actionSheet)
                        let ok = UIAlertAction(title: "باشه", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.dismissKeyboard()
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                        UserDefaults.standard.setValue(true, forKey: "AState")
                        UserDefaults.standard.setValue(self.SerialField.text!, forKey: "serial")
                        self.ActivationBtn.isHidden = true
                        self.DeactivationBtn.isHidden = false
                        self.SerialField.isUserInteractionEnabled = false
                        self.counterBegin()
                    }else if situation == "not found active code" {
                        let message = "کد فعال سازی وارد شده صحیح نمی باشد"
                        let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .actionSheet)
                        let ok = UIAlertAction(title: "باشه", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.dismissKeyboard()
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else if situation == "is code for begoo" {
                        let message = "این کد فعال سازی فقط برای اپلیکیشن بگو میباشد و قابلیت فعال سازی آن را در بگو پلاس ندارید."
                        let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .actionSheet)
                        let ok = UIAlertAction(title: "باشه", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.dismissKeyboard()
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    
    
    func Deactivation(){
        let id = UIDevice.current.identifierForVendor!.uuidString
        let serial=String(describing: SerialField.text!.convertNumToEnglish())
        //let url = "http://axaan.ir/begoo/deactive?serial=\(deviceID)&active_code=\(serial)"
        // let url = "http://axaan.ir/begoo/deactive?serial=999999999&active_code=123456"
        let url = "http://axaan.ir/begoo/deactive?serial=\(id)&active_code=\(serial)&type=begooplus"
        Alamofire.request(url).responseJSON{ response in
            switch response.result{
            case .failure(_):
                let message  = "خطا در ارتباط با سرور"
                let alert = UIAlertController(title: "خطا", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
                let settings = UIAlertAction(title: "تنظیمات", style: .default , handler: { void in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                    }
                })
                alert.addAction(ok)
                alert.addAction(settings)
                self.dismissKeyboard()
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            case .success(_):
                if let situation = (response.result.value as? Dictionary<String,String>)?["resoult"]{
                   // print(situation)
                    if situation == "not found active code or serial "{
                        let message = "همچین دستگاهی و یا کد فعال سازیی یافت نشد."
                        let alert = UIAlertController(title: "خطا", message: message, preferredStyle: .actionSheet)
                        let ok = UIAlertAction(title: "باشه", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.dismissKeyboard()
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                    }else if situation == "deactive"{
                        let message = "غیر فعال سازی موفقیت آمیز بود"
                        let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
                        let ok = UIAlertAction(title: "باشه", style: .default, handler: nil)
                        alert.addAction(ok)
                        self.dismissKeyboard()
                        DispatchQueue.main.async {
                            self.present(alert, animated: true, completion: nil)
                        }
                        UserDefaults.standard.setValue(false, forKey: "AState")
                        UserDefaults.standard.removeObject(forKey: "serial")
                        self.ActivationBtn.isHidden = false
                        self.DeactivationBtn.isHidden = true
                        self.SerialField.isUserInteractionEnabled = true
                        self.counterBegin()
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    
    func counterBegin(){
        UserDefaults.standard.setValue(true, forKey: "inTimer")
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        UserDefaults.standard.setValue(["h":hour+1,"m":minutes,"s":seconds ], forKey: "endTime")
        ActivationBtn.isUserInteractionEnabled = false
        DeactivationBtn.isUserInteractionEnabled = false
        ActivationBtn.backgroundColor = UIColor.lightGray
        ActivationBtn.titleLabel?.textColor = UIColor.darkGray
        ActivationBtn.alpha = 0.8
        DeactivationBtn.backgroundColor = UIColor.lightGray
        DeactivationBtn.titleLabel?.textColor = UIColor.darkGray
        DeactivationBtn.alpha = 0.8
        CountDownLbl.text = "01:00:00"
        CountDownLbl.isHidden = false
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1 , target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

        }
    }
    
    
    
    func update(){
        Sec-=1
        if Sec < 0 && (Min > 0 || Hour > 0){
           Min-=1
            Sec=59
        }
        if Min < 0 && Hour > 0{
            Hour-=1
            Min=59
        }
        if Sec < 0 && Min<1 && Hour<1{
            timer.invalidate()
            UserDefaults.standard.setValue(false, forKey: "inTimer")
            Hour=1
             Min=0
             Sec=0
            ActivationBtn.isUserInteractionEnabled = true
            DeactivationBtn.isUserInteractionEnabled = true
            ActivationBtn.backgroundColor = UIColor(red: 1.0/255.0, green: 140.0/255.0, blue: 203.0/255.0, alpha: 1.0)
            ActivationBtn.titleLabel?.textColor = UIColor.white
            ActivationBtn.alpha = 1
            DeactivationBtn.backgroundColor = UIColor(red: 1.0/255.0, green: 140.0/255.0, blue: 203.0/255.0, alpha: 1.0)
            DeactivationBtn.titleLabel?.textColor = UIColor.white
            DeactivationBtn.alpha = 1
            CountDownLbl.isHidden = true
            
        }else{
            if Min<10 && Sec>9{
                CountDownLbl.text = "0\(Hour):0\(Min):\(Sec)"
            }else if Min<10 && Sec<10{
                CountDownLbl.text = "0\(Hour):0\(Min):0\(Sec)"
            }else if Min>9 && Sec<10{
                CountDownLbl.text = "0\(Hour):\(Min):0\(Sec)"
            }else{
                CountDownLbl.text = "0\(Hour):\(Min):\(Sec)"
            }
        }
    }

    
    
    
    @IBAction func buyPressd (_ sender : Any) {
        
        Alamofire.request("http://axaan.ir/begoo/info?id=314").responseJSON {
            response in

            switch response.result {
            case .failure(_) :
            let message  = "خطا در ارتباط با سرور"
            let alert = UIAlertController(title: "خطا", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
            let settings = UIAlertAction(title: "تنظیمات", style: .default , handler: { void in
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                }
            })
            alert.addAction(ok)
            alert.addAction(settings)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
                }

                
            case .success(_) :
            if let info = (response.result.value as? NSDictionary) {
                DispatchQueue.main.async {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(URL(string: info.value(forKey: "url_pay") as! String)!)
                    } else {
                        UIApplication.shared.openURL(NSURL(string: info.value(forKey: "url_pay")as! String)! as URL)
                    }}
                }
            }
        }
        
        
        
    }
    
    @IBAction func contactPressd (_ sender : Any) {
        
        Alamofire.request("http://axaan.ir/begoo/info?id=314").responseJSON {
            response in
            
            switch response.result {
            case .failure(_) :
                let message  = "خطا در ارتباط با سرور"
                let alert = UIAlertController(title: "خطا", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
                let settings = UIAlertAction(title: "تنظیمات", style: .default , handler: { void in
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                    }
                })
                alert.addAction(ok)
                alert.addAction(settings)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            case .success(_) :
                if let info = (response.result.value as? NSDictionary) {
                    DispatchQueue.main.async {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: info.value(forKey: "url_telegram") as! String)!)
                        } else {
                            UIApplication.shared.openURL(NSURL(string: info.value(forKey: "url_telegram")as! String)! as URL)
                        }}
                }
            }
        }

        
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func checkThatShit(){
        if let inTimer = UserDefaults.standard.value(forKey: "inTimer") as? Bool {
            if inTimer{
                let date = Date()
                let calendar = Calendar.current
                let hour = calendar.component(.hour, from: date)
                let minutes = calendar.component(.minute, from: date)
                let seconds = calendar.component(.second, from: date)
                let endTime = UserDefaults.standard.value(forKey: "endTime") as! [String:Int]
                Hour = endTime["h"]! - hour
                Min = endTime["m"]! - minutes
                Sec = endTime["s"]! - seconds
                
                if Sec < 0 {
                    Min -= 1
                    Sec += 60
                }
                if Min < 0 {
                    Hour -= 1
                    Min += 60
                }
                
                if !(Hour < 0){
                    if Min<10 && Sec>9{
                        CountDownLbl.text = "0\(Hour):0\(Min):\(Sec)"
                    }else if Min<10 && Sec<10{
                        CountDownLbl.text = "0\(Hour):0\(Min):0\(Sec)"
                    }else if Min>9 && Sec<10{
                        CountDownLbl.text = "0\(Hour):\(Min):0\(Sec)"
                    }else{
                        CountDownLbl.text = "0\(Hour):\(Min):\(Sec)"
                    }
                    ActivationBtn.isUserInteractionEnabled = false
                    DeactivationBtn.isUserInteractionEnabled = false
                    ActivationBtn.backgroundColor = UIColor.lightGray
                    ActivationBtn.titleLabel?.textColor = UIColor.darkGray
                    ActivationBtn.alpha = 0.8
                    DeactivationBtn.backgroundColor = UIColor.lightGray
                    DeactivationBtn.titleLabel?.textColor = UIColor.darkGray
                    DeactivationBtn.alpha = 0.8
                    CountDownLbl.isHidden = false
                    DispatchQueue.main.async {
                        self.timer = Timer.scheduledTimer(timeInterval: 1 , target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
                    }
                }else{
                    Hour = 1
                    Min = 0
                    Sec = 0
                    UserDefaults.standard.setValue(false, forKey: "inTimer")
                }
            }
        }
    }
    
    @IBAction func supportPressed (_ sender : UIButton!) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: self.urls!.value(forKey: "url_telegram") as! String)!)
        } else {
            UIApplication.shared.openURL(NSURL(string: self.urls!.value(forKey: "url_telegram")as! String)! as URL)
        }
        
    }
    
    
    @IBAction func channelPressed (_ sender : UIButton) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: self.urls!.value(forKey: "ch_telegram") as! String)!)
        } else {
            UIApplication.shared.openURL(NSURL(string: self.urls!.value(forKey: "ch_telegram")as! String)! as URL)
        }
        
    }

    
    @IBAction func backPressed(_ sender:UIButton!){
        performSegue(withIdentifier: "toSetting", sender: nil)
    }
    func back(){
       performSegue(withIdentifier: "toSetting", sender: nil) 
    }
    
    func scrollViewButtonTapped (_ sender : UIButton!) {
        
        if let u = urls {
            openUrl(tag: sender.tag)
        }
        
        else {
            
            self.view.blurTheView(view: self.view)
            Alamofire.request("http://axaan.ir/begoo/info?id=314").responseJSON {
                response in
                
                switch response.result {
                case .failure(_) :
                    let message  = "خطا در ارتباط با سرور"
                    let alert = UIAlertController(title: "خطا", message: message, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
                    let settings = UIAlertAction(title: "تنظیمات", style: .default , handler: { void in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString)! as URL)
                        }
                    })
                    alert.addAction(ok)
                    alert.addAction(settings)
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: {
                            void in
                            self.view.deBlurTheView(view: self.view)
                        })
                    }
                    
                    
                case .success(_) :
                    if let info = (response.result.value as? NSDictionary) {
//                        DispatchQueue.main.async {
//                            if #available(iOS 10.0, *) {
//                                UIApplication.shared.open(URL(string: info.value(forKey: "url_telegram") as! String)!)
//                            } else {
//                                UIApplication.shared.openURL(NSURL(string: info.value(forKey: "url_telegram")as! String)! as URL)
//                            }}
                        self.urls = info
                        self.view.deBlurTheView(view: self.view)
                        self.openUrl(tag: sender.tag)
                        
                    }
                }
            }

        }
        
        
        
        
        
        
        
        
    
}

    func openUrl (tag : Int) {
        if tag == 1 {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: self.urls!.value(forKey: "site") as! String)!)
            } else {
                UIApplication.shared.openURL(NSURL(string: self.urls!.value(forKey: "site")as! String)! as URL)
            }
            
        }
            
        else if tag == 2 {
            
           showDashboard()
        }
            
            
        else if tag == 3 {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "tel://\(self.urls!.value(forKey: "tel") as! String)")!)
            } else {
                UIApplication.shared.openURL(NSURL(string: "tel://\(self.urls!.value(forKey: "tel") as! String)")! as URL)
            }

        }
            
        else if tag == 4 {
            
            if #available(iOS 10.0, *) {
                if UIApplication.shared.canOpenURL(URL(string: "instagram://user?username=begooapp")!){
                    UIApplication.shared.open(URL(string: "instagram://user?username=begooapp")!)}
                else {
                    UIApplication.shared.openURL(URL(string: self.urls?.value(forKey: "instagram") as! String)!)
                }
            } else {
                if  UIApplication.shared.canOpenURL(NSURL(string: self.urls!.value(forKey: "instagram")as! String)! as URL) {
                    UIApplication.shared.openURL(NSURL(string: ("instagram://user?username=begooapp"))! as URL)
                }
                else{
                    UIApplication.shared.openURL(NSURL(string: self.urls!.value(forKey: "instagram")as! String)! as URL)
                }
                
                
                
            }
            
        }
    }
    
    func dismissDashboard() {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveLinear, animations: {
            
            self.topCnstraint.constant = -150
            self.view.layoutIfNeeded()
            
        }, completion: nil)
    }
    
    
    func showDashboard () {
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .curveLinear, animations: {
            
            self.topCnstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
        
        
        
    }
    
    
    
}
let Formatter: NumberFormatter = NumberFormatter()

extension String {
    
    func convertNumToEnglish () -> String {
        Formatter.locale = Locale(identifier: "EN")
        let final = Formatter.number(from: self)
        let fin = final!.stringValue
        return fin
    }
    
}


extension UIView {
    
    func addSubViews (views : [UIView]){
        
        for view in views {
            self.addSubview(view)
        }
    }
    
    func blurTheView (view:UIView) {
        let blurredView = UIVisualEffectView()
        blurredView.frame = view.frame
        blurredView.effect = UIBlurEffect(style: .dark)
        let frame = CGRect(x: (blurredView.frame.width - 30) / 2, y: (blurredView.frame.height - 30) / 2, width: 30, height: 30)
        let sher = UIActivityIndicatorView(frame: frame)
        sher.startAnimating()
        blurredView.addSubview(sher)
        view.addSubview(blurredView)
    }
    
    
    
    func deBlurTheView (view: UIView) {
        for v in view.subviews {
            if v is UIVisualEffectView {
                v.removeFromSuperview()
            }
        }
    }
    
    
}
