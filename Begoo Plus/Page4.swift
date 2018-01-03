//
//  Page4.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/27/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import SQLite
class Page4: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var Lbl: UILabel!
    @IBOutlet weak var Tableview: UITableView!
    var ParentID:Int = 0
    var ID = [Int]()
    let reuseId = "Cell"
    let heightforcell = screenSize.height/3
    var guruhesh = ""
    var Name=[String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
        try sqlReading()
        } catch {print("exp")}
        if(lvl==2 && ParentID==3){
            if ID.contains(1){
                ID.remove(at: ID.index(of: 1)!)
            }
            
        }
        if(lvl==1 && ParentID==3){
            if ID.contains(2){
                ID.remove(at: ID.index(of: 2)!)
            }
            if ID.contains(3){
                ID.remove(at: ID.index(of: 3)!)
            }
        }
        if lvl==1 {
           // print(Name)
            if let values = UserDefaults.standard.value(forKey: "fund") as? [String]{
             //   print("lvl one")
              //  print(values)
                for item in values {
                    if Name.contains(item){
                      //  print("removed")
                        ID.remove(at: Name.index(of: item)!)
                        Name.remove(at: Name.index(of: item)!)
                    }
                }
            }
        }else if lvl==2 {
          //  print(Name)

            if let values = UserDefaults.standard.value(forKey: "pro") as? [String]{
              //  print("lvl two")

                for item in values {
                    if Name.contains(item){
                        ID.remove(at: Name.index(of: item)!)
                        Name.remove(at: Name.index(of: item)!)
                    }
                }
            }
        }
        Lbl2 = Lbl1 + " - " + guruhesh
        Tableview.delegate = self
        Tableview.dataSource = self
        let nib = UINib(nibName: "Page4Cells", bundle: nil)
        Tableview.register(nib,forCellReuseIdentifier: reuseId)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Lbl.text = Lbl2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Page4Cells = self.Tableview.dequeueReusableCell(withIdentifier: reuseId)! as! Page4Cells
        let path: String? = Bundle.main.path(forResource: "\(ID[indexPath.row])", ofType: "jpg", inDirectory: "names/\(ParentID)")
        let imageFromPath = UIImage(contentsOfFile: path!)!
        cell.cellImage.image = imageFromPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let path: String? = Bundle.main.path(forResource: "\(ID[indexPath.row])", ofType: "jpg", inDirectory: "names/\(ParentID)")
//        let imageFromPath = UIImage(contentsOfFile: path!)!
//        return imageFromPath.size.height - 100
        return heightforcell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(Amoozesh){
            performSegue(withIdentifier: "toPage5", sender: indexPath.row)
        }else{
            if (UserDefaults.standard.value(forKey: "AState") as? Bool)! || (preActive=="yes") {
                performSegue(withIdentifier: "toTestVC", sender: indexPath.row)
                
            }else if preActive == "block"{
                let message  = "در حال حاضر تنها قادر به دیدن بخش های مختلف برنامه هستید اما امکان استفاده از آنها نیست.برای استفاده از بخش های مختلف برنامه اقدام به فعال سازی برنامه بکنید."
                let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
                alert.addAction(ok)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }else if countforfree < 2 {
                performSegue(withIdentifier: "toTestVC", sender: indexPath.row)
            }else{
                let message  = "در نسخه ی دمو تنها ۲ بار قادر به استفاده از بخش آزمون هستید.\nلطفا برای استفاده ی مجدد از این بخش و بقیه امکانات اپلیکیشن٬اقدام به فعال سازی بفرمایید."
                let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "باشه", style: .default , handler: nil)
                alert.addAction(ok)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        Uplayer.play()
    }
    
    func sqlReading() throws {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fullPath = paths[0] as NSString
        let path = fullPath.appendingPathComponent("BegooPlus.db")
        let db = try Connection(path)
        for item in try db.prepare(table){
            if lvl == 1 {
            if(Int(item[id_gr1])==ParentID && Int(item[level]) == 1){
                if(!ID.contains(Int(item[id_gr2]))){
                    ID.append(Int(item[id_gr2]))
                    guruhesh = item[gr1]!
                    if item[gr1] == "حروف" {
                        Name.append(item[gr1]!+" ")
                    }else{
                        Name.append(item[gr2]!)
                    }
                }
            }
        }
            
            else if lvl == 2 {
                if(Int(item[id_gr1])==ParentID && Int(item[level]) == 2){
                    if(!ID.contains(Int(item[id_gr2]))){
                        ID.append(Int(item[id_gr2]))
                        guruhesh = item[gr1]!
                        //if item[gr1] == "حروف" {
                         //   Name.append(item[gr1]!+" ")
                       // }else{
                            Name.append(item[gr2]!)
                       // }
                    }
                }
                
                
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPage5"{
            if let vc = segue.destination as? Page5 {
                if let index = sender as? Int{
                    vc.ParentID = ID[index]
                    vc.ParentParentID = ParentID
                }
            }
        }
        if segue.identifier == "toTestVC"{
            if let vc = segue.destination as? TestVC {
                if let index = sender as? Int{
                    vc.ParentID = ID[index]
                    vc.ParentParentID = ParentID
                }
            }
        }
    }
    
}
