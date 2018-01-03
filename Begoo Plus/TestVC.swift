//
//  TestVC.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/28/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import SQLite
import AVFoundation
import Gifu
class TestVC: UIViewController {
    
    
    @IBOutlet weak var AnswerViewBtn: UIButton!
    @IBOutlet weak var AnswerImgNOW: GIFImageView!
    @IBOutlet weak var AnswerImgNEXT: GIFImageView!
    @IBOutlet weak var AnswerView: UIView!
    @IBOutlet weak var WrongLbl: UILabel!
    @IBOutlet weak var CorrectLbl: UILabel!
    @IBOutlet var Btn: [QuestionBtn]!
    @IBOutlet var Gif: [GIFImageView]!
    @IBOutlet weak var PauseView: UIView!
    @IBOutlet weak var PauseBtn: UIButton!
    var A = false
    var noUcant = false
    var ParentID = 0
    var ParentParentID = 0
    var ID = [Int]()
    var GeneratedRandom = [Int]()
    var player: AVAudioPlayer?
    var CWplayer: AVAudioPlayer?
    var Wrong=0
    var Correct=0
    var counter=0
    var safe = true
    var timer = Timer()
    var firsttime = true
    var NOWnext_Switcher = "NOW"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firsttime = true
        countforfree+=1
        UserDefaults.standard.setValue(countforfree, forKey: "countforfree")
        A = UserDefaults.standard.value(forKey: "AState") as! Bool
        Wrong=0
        Correct=0
        counter=0
        GeneratedRandom.removeAll()
        do{
            try sqlReading()
        }catch{print("exp")}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        randomQuestion()
        
        AnswerView.layer.borderWidth = 8
        AnswerView.layer.borderColor = UIColor.cyan.cgColor
        PauseView.isHidden = true
        PauseBtn.isHidden = false
    }
  
    
    func sqlReading() throws {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fullPath = paths[0] as NSString
        let path = fullPath.appendingPathComponent("BegooPlus.db")
        let db = try Connection(path)
        for item in try db.prepare(table){
            if(Int(item[id_gr2])==ParentID && Int(item[level])==lvl && Int(item[id_gr1])==ParentParentID){
                if let name = item[name1]{
                    ID.append(Int(item[id_name]))
                }
            }
        }
    }

    func randomQuestion(){
        counter += 1
        for btn in Btn {
            btn.isAnswer = false
        }
        while GeneratedRandom.count<4 {
            let randomNum:UInt32 = arc4random_uniform(UInt32(ID.count))
            let someInt:Int = Int(randomNum)
                if(!GeneratedRandom.contains(someInt)){
                    let path: String? = Bundle.main.path(forResource: "\(ID[someInt])", ofType: "gif", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)")

                    Gif[GeneratedRandom.count].animate(withGIFNamed: path!)
                    Btn[GeneratedRandom.count].path = path!

                    GeneratedRandom.append(someInt)
                }
        }
        let randomNum:UInt32 = arc4random_uniform(UInt32(GeneratedRandom.count))
        let someInt:Int = Int(randomNum)
        Btn[someInt].isAnswer = true
        
        
        let path: String? = Bundle.main.path(forResource: "\(ID[GeneratedRandom[someInt]])", ofType: "mp3", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)/s")
        let url = URL(fileURLWithPath: path!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
        } catch let error {print(error.localizedDescription)}
        if firsttime {
            player?.play()
            AnswerImgNEXT.animate(withGIFNamed: Btn[someInt].path)
        }
        if NOWnext_Switcher == "NOW"{
            AnswerImgNOW.animate(withGIFNamed: Btn[someInt].path)
            NOWnext_Switcher = "NEXT"
            AnswerImgNEXT.isHidden = false
            AnswerImgNOW.isHidden = true
        }else if NOWnext_Switcher == "NEXT"{
            AnswerImgNEXT.animate(withGIFNamed: Btn[someInt].path)
            NOWnext_Switcher = "NOW"
            AnswerImgNEXT.isHidden = true
            AnswerImgNOW.isHidden = false
        }
        firsttime = false
        
        
    }
    
    @IBAction func BtnPressed(_ sender: UIButton) {
        player?.stop()
        if Btn[sender.tag-1].isAnswer {
            let path: String? = Bundle.main.path(forResource: "correct", ofType: "mp3")
            let url = URL(fileURLWithPath: path!)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                CWplayer = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }
            } catch let error {print(error.localizedDescription)}
            CWplayer?.play()
            if !noUcant{
                Correct += 1
            }
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {void in
                    self.AnswerView.isHidden = false
                    self.AnswerViewBtn.isHidden = false
                    self.CorrectLbl.text = "تعداد صحیح : \(self.Correct)"
                    self.noUcant = false
                    if(self.counter-1 != QuestionCount){
                        self.GeneratedRandom.removeAll()
                        self.randomQuestion()
                    }
                    self.timer.invalidate()
                })
            } else {
                self.AnswerView.isHidden = false
                self.AnswerViewBtn.isHidden = false
                self.CorrectLbl.text = "تعداد صحیح : \(self.Correct)"
                self.noUcant = false
                if(self.counter-1 != QuestionCount){
                    self.GeneratedRandom.removeAll()
                    self.randomQuestion()
                }
            }
            
            
        }else{
            let path: String? = Bundle.main.path(forResource: "wrong", ofType: "wav")
            let url = URL(fileURLWithPath: path!)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                CWplayer = try AVAudioPlayer(contentsOf: url)
                guard let player = player else { return }
            } catch let error {print(error.localizedDescription)}
                CWplayer?.play()
            Wrong += 1
            WrongLbl.text = "تعداد غلط : \(Wrong)"
            noUcant = true
        }
    }
    
    @IBAction func PlaySound(_ sender: UIButton) {
        
        player?.play()
    }
   
    @IBAction func answerViewBtnPressed(_ sender: Any) {
        if counter > 4 {
            if A || (preActive=="yes"){
                if(counter-1 != QuestionCount){
                    print(counter)
//                    GeneratedRandom.removeAll()
//                    randomQuestion()
                }else{
                    let currentDate = Date()
                    let calendar = Calendar.current
                    let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                    
                    let date = toJalaali(gy: components.year!, components.month!, components.day!)
                    
                    let JalaaliDate = "\(date.year)/\(month[date.month-1])/\(date.day)"
                   // print(JalaaliDate)
                    let Percentage = String(format: "%.1f", Float((Double(Correct)/Double(QuestionCount))*100))
                        if let item = Results.last {
                            if (item["Date"] as! String) == JalaaliDate{
                                let count = (item["Count"] as! Int) + QuestionCount
                                let correct = (item["Correct"] as! Int) + Correct
                                let wrong = (item["Wrong"] as! Int) + Wrong
                                let Perc = String(format: "%.1f", Float((Double(correct)/Double(count))*100))
                                Results.popLast()
                                Results.append(["Date": JalaaliDate ,"Count":count,"Correct":correct,"Wrong":wrong,"Percentage":Perc])
                            }else{
                                 Results.append(["Date": JalaaliDate ,"Count":QuestionCount,"Correct":Correct,"Wrong":Wrong,"Percentage":Percentage])
                            }
                        }else{
                             Results.append(["Date": JalaaliDate ,"Count":QuestionCount,"Correct":Correct,"Wrong":Wrong,"Percentage":Percentage])
                        }
                    UserDefaults.standard.setValue(Results, forKey: "Results")
                    performSegue(withIdentifier: "toAfterTest", sender: nil)
                }
                if #available(iOS 10.0, *) {
                    timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {void in
                        self.AnswerViewBtn.isHidden = true
                        self.AnswerView.isHidden = true
                        if self.counter-1 != QuestionCount{
                            self.player?.play()
                        }
                        self.timer.invalidate()
                    })
                } else {
                    self.AnswerViewBtn.isHidden = true
                    self.AnswerView.isHidden = true
                    if counter-1 != QuestionCount{
                        self.player?.play()
                    }
                }
                
            }else{
                let message  = "در حال حاضر این نسخه٬دمو می باشد.\nلطفا برای استفاده ازامکانات و اطلاعات بیشتر اقدام به فعال سازی فرمایید."
                let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "فعلا نمیخوام", style: .default , handler: {void in
                    self.AnswerViewBtn.isHidden = true
                    self.AnswerView.isHidden = true
                    self.performSegue(withIdentifier: "backtoPage4Az", sender: nil)
                })
                let settings = UIAlertAction(title: "فعال سازی", style: .default , handler: { void in
                    self.performSegue(withIdentifier: "toActive", sender: nil)
                })
                alert.addAction(ok)
                alert.addAction(settings)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
            
        }else{
            
            if(counter-1 != QuestionCount){
//                GeneratedRandom.removeAll()
//                randomQuestion()
            }else{
                let currentDate = Date()
                let calendar = Calendar.current
                let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
                
                let date = toJalaali(gy: components.year!, components.month!, components.day!)
                
                let JalaaliDate = "\(date.year)/\(month[date.month-1])/\(date.day)"
               // print(JalaaliDate)
                let Percentage = String(format: "%.1f", Float((Double(Correct)/Double(QuestionCount))*100))
                if let item = Results.last {
                    if (item["Date"] as! String) == JalaaliDate{
                        let count = (item["Count"] as! Int) + QuestionCount
                        let correct = (item["Correct"] as! Int) + Correct
                        let wrong = (item["Wrong"] as! Int) + Wrong
                        let Perc = String(format: "%.1f", Float((Double(correct)/Double(count))*100))
                        Results.popLast()
                        Results.append(["Date": JalaaliDate ,"Count":count,"Correct":correct,"Wrong":wrong+1,"Percentage":Perc])
                    }else{
                        Results.append(["Date": JalaaliDate ,"Count":QuestionCount,"Correct":Correct,"Wrong":Wrong+1,"Percentage":Percentage])
                    }
                }else{
                    Results.append(["Date": JalaaliDate ,"Count":QuestionCount,"Correct":Correct,"Wrong":Wrong+1,"Percentage":Percentage])
                }
                UserDefaults.standard.setValue(Results, forKey: "Results")
                performSegue(withIdentifier: "toAfterTest", sender: nil)
            }
            if #available(iOS 10.0, *) {
                timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: {void in
                    self.AnswerViewBtn.isHidden = true
                    self.AnswerView.isHidden = true
                    if self.counter-1 != QuestionCount{
                        self.player?.play()
                    }
                    self.timer.invalidate()
                })
            } else {
                self.AnswerViewBtn.isHidden = true
                self.AnswerView.isHidden = true
                if counter-1 != QuestionCount{
                    self.player?.play()
                }
            }
            
        }
    }

    @IBAction func pausePressed(_ sender: Any) {
        PauseBtn.isHidden = true
        PauseView.isHidden = false
    }
    @IBAction func BackPressed(_ sender: Any) {
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        let date = toJalaali(gy: components.year!, components.month!, components.day!)
        
        let JalaaliDate = "\(date.year)/\(month[date.month-1])/\(date.day)"
       // print(JalaaliDate)
        let Percentage = String(format: "%.1f", Float((Double(Correct)/Double(QuestionCount))*100))
        if let item = Results.last {
            if (item["Date"] as! String) == JalaaliDate{
                let count = (item["Count"] as! Int) + QuestionCount
                let correct = (item["Correct"] as! Int) + Correct
                let wrong = (item["Wrong"] as! Int) + Wrong
                let Perc = String(format: "%.1f", Float((Double(correct)/Double(count))*100))
                Results.popLast()
                Results.append(["Date": JalaaliDate ,"Count":count,"Correct":correct,"Wrong":wrong,"Percentage":Perc])
            }else{
                Results.append(["Date": JalaaliDate ,"Count":QuestionCount,"Correct":Correct,"Wrong":Wrong,"Percentage":Percentage])
            }
        }else{
            Results.append(["Date": JalaaliDate ,"Count":QuestionCount,"Correct":Correct,"Wrong":Wrong,"Percentage":Percentage])
        }
        UserDefaults.standard.setValue(Results, forKey: "Results")
        performSegue(withIdentifier: "backtoPage4Az", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backtoPage4Az"{
            if let vc = segue.destination as? Page4 {
                vc.ParentID = ParentParentID
            }
        }
        if segue.identifier == "toAfterTest"{
            if let vc = segue.destination as? AfterTest {
                vc.correct = self.Correct
                vc.wrong = self.Wrong
            }
            
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        player?.play()
    }

    @IBAction func PauseViewHider(_ sender: Any) {
        PauseView.isHidden = true
        PauseBtn.isHidden = false
    }
}

