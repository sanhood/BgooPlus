//
//  Page3.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/27/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import SQLite
class Page3: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var Tableview: UITableView!
    @IBOutlet weak var Home: UIButton!
    @IBOutlet weak var Result: UIButton!
    @IBOutlet weak var calView: UIView!
    @IBOutlet weak var calLbl: UILabel!
    @IBOutlet weak var calTF: UITextField!
    @IBOutlet weak var DisablerView: UIView!
    var num1 = 1
    var num2 = 1
    let reuseId = "Cell"
    var ID = [Int]()
    var Name = [String]()
    let heightforcell = screenSize.height/3
    @IBOutlet weak var Lbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        do{
            try sqlReading()
        } catch{print("exp")}
        
        if(lvl==2){
            if ID.contains(2){
                ID.remove(at: ID.index(of: 2)!)
            }
            
        }
        if Amoozesh {
            if lvl == 1{
                Lbl1 = "مقدماتی - آموزش"
            }else{
                Lbl1 = "پیشرفته - آموزش"
            }
        }else {
            if lvl == 1{
                Lbl1 = "مقدماتی - آزمون"
            }else{
                Lbl1 = "پیشرفته - آزمون"
            }
        }
        
        if lvl==1 {
            if let values = UserDefaults.standard.value(forKey: "fund") as? [String]{
                for item in values {
                    if Name.contains(item){
                        ID.remove(at: Name.index(of: item)!)
                        Name.remove(at: Name.index(of: item)!)
                    }
                }
            }
        }else if lvl==2 {
            if let values = UserDefaults.standard.value(forKey: "pro") as? [String]{
               // print(values)
                //print(Name)
                //print(ID)
                for item in values {
                  //  print(item)

                    if Name.contains(item){
                        ID.remove(at: Name.index(of: item)!)
                        Name.remove(at: Name.index(of: item)!)
                    }
                }
            }
        }
       

        Tableview.delegate = self
        Tableview.dataSource = self
        let nib = UINib(nibName: "Page3Cells", bundle: nil)
        Tableview.register(nib,forCellReuseIdentifier: reuseId)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         Lbl.text! = Lbl1
        if Amoozesh{
            Home.isHidden = false
            Result.isHidden = true
        }else{
            Home.isHidden = true
            Result.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Page3Cells = self.Tableview.dequeueReusableCell(withIdentifier: reuseId)! as! Page3Cells
                let path: String? = Bundle.main.path(forResource: "\(ID[indexPath.row])", ofType: "jpg", inDirectory: "names")
                let imageFromPath = UIImage(contentsOfFile: path!)!
                cell.cellImage.image = imageFromPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let path: String? = Bundle.main.path(forResource: "\(ID[indexPath.row])", ofType: "jpg", inDirectory: "names")
//        let imageFromPath = UIImage(contentsOfFile: path!)!
//        return imageFromPath.size.height - 100
        return heightforcell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toPage4", sender: indexPath.row)
        Uplayer.play()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "Page4") as! Page4
//        vc.ParentID = ID[indexPath.row]
//        self.present(vc, animated: true, completion: nil)


    }
 
    
    func sqlReading() throws {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fullPath = paths[0] as NSString
        let path = fullPath.appendingPathComponent("BegooPlus.db")
        let db = try Connection(path)
        for item in try db.prepare(table){
            
            if (lvl == 1) {
            
            if(!ID.contains(Int(item[id_gr1])) && Int(item[level]) == 1){
                ID.append(Int(item[id_gr1]))
                Name.append(item[gr1]!)
            }
            
            }
            else if (lvl == 2) {
               
                if(!ID.contains(Int(item[id_gr1])) && Int(item[level]) == 2){
                    ID.append(Int(item[id_gr1]))
                    Name.append(item[gr1]!)
                }
                
            }
            
            
            
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toPage4"){
            if let vc = segue.destination as? Page4 {
                if let index = sender as? Int{
                   vc.ParentID = ID[index]
                }
            }
        }
    }
    
    
    @IBAction func CalBtnPressed(_ sender: UIButton) {
        calTF.text = calTF.text! + "\(sender.tag)"
        if (calTF.text?.characters.count)! < 3 && (calTF.text?.characters.count)! > 0 {
            if Int(calTF.text!)! == num1*num2 {
                performSegue(withIdentifier: "toRes", sender: nil)
                calTF.text = ""
            }else if (calTF.text?.characters.count)! == 2 {
                calView.isHidden = true
                DisablerView.isHidden = true
                calTF.text = ""
            }
        }
    }
    
    @IBAction func ResPressed(_ sender: Any) {
        if preActive != "block" {
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
        }else {
            let message  = "در حال حاضر تنها قادر به دیدن بخش های مختلف برنامه هستید اما امکان استفاده از آنها نیست.برای استفاده از بخش های مختلف برنامه اقدام به فعال سازی برنامه بکنید."
            let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
            alert.addAction(ok)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }  
    }

}
