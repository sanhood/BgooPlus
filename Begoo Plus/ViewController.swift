//Danoosh
//
//  ViewController.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/26/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController  {
    @IBOutlet weak var ViewofBtns: UIView!
    var Size : CGRect!
    @IBOutlet weak var calView: UIView!
    @IBOutlet weak var calLbl: UILabel!
    @IBOutlet weak var wait: UIActivityIndicatorView!
    @IBOutlet weak var calTF: UITextField!
    @IBOutlet weak var DisablerView: UIView!
    var num1 = 1
    var num2 = 1
    var tag = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        Size = CGRect(x: screenSize.minX, y: screenSize.midY+55, width: screenSize.width, height: screenSize.height-55)
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
        if let lvlishide = UserDefaults.standard.value(forKey: "lvlishide") as? String{
            if lvlishide=="pro"{
                calTF.text = ""
                let Btn1 = UIButton()
                Btn1.tag = 0
                Btn1.setImage(UIImage(named: "level1"), for: .normal)
                Btn1.imageView?.contentMode = .scaleAspectFit
                Btn1.backgroundColor = UIColor.white
                Btn1.addTarget(self, action: #selector(act), for: .touchUpInside)
                Btn1.translatesAutoresizingMaskIntoConstraints = false
                ViewofBtns.addSubview(Btn1)
                let pintop = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
                let pinleft = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
                let pinright = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
                let height = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (Size.height/2))
                ViewofBtns.addConstraints([pintop,pinleft,pinright,height])
                ViewofBtns.backgroundColor = UIColor.clear
            
                
            }else if lvlishide=="fund"{
                calTF.text = ""
                let Btn2 = UIButton()
                Btn2.tag = 1
//                Btn2.setBackgroundImage(UIImage(named: "level2"), for: .normal)
                Btn2.setImage(UIImage(named: "level2"), for: .normal)
                Btn2.imageView?.contentMode = .scaleAspectFit
                Btn2.addTarget(self, action: #selector(act), for: .touchUpInside)
                Btn2.backgroundColor = UIColor.white
                Btn2.translatesAutoresizingMaskIntoConstraints = false
                ViewofBtns.addSubview(Btn2)
                let pintop = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
                let pinleft = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
                let pinright = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
                let height = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: Size.height/2)
                ViewofBtns.addConstraints([pintop,pinleft,pinright,height])
                ViewofBtns.backgroundColor = UIColor.clear
                
            }else {
                calTF.text = ""
                var Btn1 = UIButton()
                var Btn2 = UIButton()
                Btn1.tag = 0
                Btn2.tag = 1
//                Btn1.setBackgroundImage(UIImage(named: "level1"), for: .normal)
//                Btn2.setBackgroundImage(UIImage(named: "level2"), for: .normal)
                Btn1.setImage(UIImage(named: "level1"), for: .normal)
                Btn2.setImage(UIImage(named: "level2"), for: .normal)
                Btn1.imageView?.contentMode = .scaleAspectFit
                Btn2.imageView?.contentMode = .scaleAspectFit
                Btn1.backgroundColor = UIColor.white
                Btn2.backgroundColor = UIColor.white
                Btn1.addTarget(self, action: #selector(act), for: .touchUpInside)
                Btn2.addTarget(self, action: #selector(act), for: .touchUpInside)
                Btn1.translatesAutoresizingMaskIntoConstraints = false
                Btn2.translatesAutoresizingMaskIntoConstraints = false
                ViewofBtns.addSubview(Btn1)
                ViewofBtns.addSubview(Btn2)
                let pintop = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
                let pinleft = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
                let pinright = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
                let height = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (Size.height/2)-1)
                ViewofBtns.addConstraints([pintop,pinleft,pinright,height])
                let pinbtm2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
                let pinleft2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
                let pinright2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
                let height2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (Size.height/2)-1)
                ViewofBtns.addConstraints([pinbtm2,pinleft2,pinright2,height2])
            }
        }else{
            calTF.text = ""
            var Btn1 = UIButton()
            var Btn2 = UIButton()
            Btn1.tag = 0
            Btn2.tag = 1
//            Btn1.setBackgroundImage(UIImage(named: "level1"), for: .normal)
//            Btn2.setBackgroundImage(UIImage(named: "level2"), for: .normal)
            Btn1.setImage(UIImage(named: "level1"), for: .normal)
            Btn2.setImage(UIImage(named: "level2"), for: .normal)
            Btn1.imageView?.contentMode = .scaleAspectFit
            Btn2.imageView?.contentMode = .scaleAspectFit
            Btn1.backgroundColor = UIColor.white
            Btn2.backgroundColor = UIColor.white
            Btn1.addTarget(self, action: #selector(act), for: .touchUpInside)
            Btn2.addTarget(self, action: #selector(act), for: .touchUpInside)
            Btn1.translatesAutoresizingMaskIntoConstraints = false
            Btn2.translatesAutoresizingMaskIntoConstraints = false
            ViewofBtns.addSubview(Btn1)
            ViewofBtns.addSubview(Btn2)
            let pintop = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            let pinleft = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            let pinright = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            let height = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (Size.height/2)-1)
            ViewofBtns.addConstraints([pintop,pinleft,pinright,height])
            let pinbtm2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            let pinleft2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            let pinright2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            let height2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (Size.height/2)-1)
            ViewofBtns.addConstraints([pinbtm2,pinleft2,pinright2,height2])
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
    func act(sender: UIButton!) {
        Uplayer.play()
        if !(UserDefaults.standard.value(forKey: "FirstConnection") as! Bool){
            DisablerView.isHidden = false
            wait.startAnimating()
            wait.isHidden = false
            firstConnection()
        }else{
            if(sender.tag == 0){
               lvl = 1
            }else{
              lvl = 2
            }
            performSegue(withIdentifier: "toPage2", sender: nil)
        }
        
    }
    @IBAction func CalBtnPressed(_ sender: UIButton) {
        
        calTF.text = calTF.text! + "\(sender.tag)"
        if (calTF.text?.characters.count)! < 3 && (calTF.text?.characters.count)! > 0 {
            if Int(calTF.text!)! == num1*num2 {
                if tag=="Setting"{
                performSegue(withIdentifier: "toSetting", sender: nil)
                calTF.text = ""
                }else if tag == "Exit"{
                    exit(0)
                }
            }else if (calTF.text?.characters.count)! == 2 {
                calView.isHidden = true
                DisablerView.isHidden = true
                calTF.text = ""
            }
        }
    }
    
    @IBAction func SettingPressed(_ sender: Any) {
        if !(UserDefaults.standard.value(forKey: "FirstConnection") as! Bool){
            DisablerView.isHidden = false
            wait.startAnimating()
            wait.isHidden = false
            firstConnection()
        }else{
            tag="Setting"
            DisablerView.isHidden = false
            calView.isHidden = false
            var randomNum:UInt32 = arc4random_uniform(UInt32(5))
            num1 = Int(randomNum)+1
            randomNum = arc4random_uniform(UInt32(5))
            num2 = Int(randomNum)+1
            while (num1*num2)%10==0 {
                var randomNum:UInt32 = arc4random_uniform(UInt32(5))
                num1 = Int(randomNum)+1
                randomNum = arc4random_uniform(UInt32(5))
                num2 = Int(randomNum)+1
            }
            calLbl.text = "\(num1) x \(num2) ="
        }
        

    }
    @IBAction func ExitPressed(_ sender: Any) {
        tag="Exit"
        DisablerView.isHidden = false
        calView.isHidden = false
        var randomNum:UInt32 = arc4random_uniform(UInt32(5))
        num1 = Int(randomNum)+1
        randomNum = arc4random_uniform(UInt32(5))
        num2 = Int(randomNum)+1
        while (num1*num2)%10==0 {
            var randomNum:UInt32 = arc4random_uniform(UInt32(5))
            num1 = Int(randomNum)+1
            randomNum = arc4random_uniform(UInt32(5))
            num2 = Int(randomNum)+1
        }
        calLbl.text = "\(num1) x \(num2) ="
    }
    
    func firstConnection(){
        Alamofire.request("http://axaan.ir/begoo/info?id=314").responseJSON {
            response in
            switch response.result {
            case .failure(_) :
                DispatchQueue.main.async {
                    self.DisablerView.isHidden = true
                    let message = "لطفا برای تنظیمات اولیه ی برنامه دستگاه خود را به اینترنت متصل کنید.اجراهای بعدی برنامه نیازی به اینترنت ندارد."
                    let alert = UIAlertController(title: "توجه", message: message , preferredStyle: .alert)
                    let action = UIAlertAction(title: "باشه", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            case .success(_) :
                DispatchQueue.main.async {
                    self.DisablerView.isHidden = true
                }
                UserDefaults.standard.setValue(true, forKey: "FirstConnection")
                if let info = (response.result.value as? NSDictionary) {
                    if (info["ios"] as! String) == "yes" {
                        UserDefaults.standard.setValue("yes", forKey: "preActive")
                    }else if (info["ios"] as! String) == "no" {
                        UserDefaults.standard.setValue("no", forKey: "preActive")
                    }else {
                        UserDefaults.standard.setValue("block", forKey: "preActive")
                    }
                }
            }
        }
    }
    
}
//soroush
