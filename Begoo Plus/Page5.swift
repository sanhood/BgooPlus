//
//  Page5.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/27/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import SQLite
class Page5: UIViewController ,UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var Tableview: UITableView!
    @IBOutlet weak var Lbl: UILabel!
    var ParentID:Int = 1
    var ParentParentID: Int = 0
    var ID = [Int]()
    var Name = [String]()
    let reuseId = "Cell"
    var guruhesh = ""
    var A = false
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try sqlReading()
        } catch {print("exp")}
        A = UserDefaults.standard.value(forKey: "AState") as! Bool
       // print(ID.count)
        Lbl3 = Lbl2 + " - " + guruhesh + " ( \(ID.count) )"
        Tableview.delegate = self
        Tableview.dataSource = self
        let nib = UINib(nibName: "Page5Cells", bundle: nil)
        Tableview.register(nib,forCellReuseIdentifier: reuseId)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Lbl.text = Lbl3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Page5Cells = self.Tableview.dequeueReusableCell(withIdentifier: reuseId)! as! Page5Cells
        let path: String? = Bundle.main.path(forResource: "\(ID[indexPath.row])", ofType: "gif", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)")
        let imageFromPath = UIImage(contentsOfFile: path!)!
        cell.cellImage.image = imageFromPath
        cell.cellImage.layer.cornerRadius = 2
        cell.cellLbl.text = Name[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let path: String? = Bundle.main.path(forResource: "\(ID[indexPath.row])", ofType: "JPG", inDirectory: "names/begoo/\(ParentParentID)/\(ParentID)")
//        let imageFromPath = UIImage(contentsOfFile: path!)!
//        
//        return imageFromPath.size.height - 100
        return 117
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 4 {
            if A || (preActive=="yes"){
                performSegue(withIdentifier: "toPage6", sender: indexPath.row)
                Uplayer.play()
            }else{
                let message  = "در حال حاضر این نسخه٬دمو می باشد.\nلطفا برای استفاده ازامکانات و اطلاعات بیشتر اقدام به فعال سازی فرمایید."
                let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "فعلا نمیخوام", style: .default , handler: nil)
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
            if preActive != "block" {
                performSegue(withIdentifier: "toPage6", sender: indexPath.row)
                Uplayer.play()
            }else {
                let message  = "در حال حاضر این نسخه٬دمو می باشد.\nلطفا برای استفاده ازامکانات و اطلاعات بیشتر اقدام به فعال سازی فرمایید."
                let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "فعلا نمیخوام", style: .default , handler: nil)
                let settings = UIAlertAction(title: "فعال سازی", style: .default , handler: { void in
                    self.performSegue(withIdentifier: "toActive", sender: nil)
                })
                alert.addAction(ok)
                alert.addAction(settings)
                DispatchQueue.main.async {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "Page6") as! Page6
//        vc.currentIndex = indexPath.row
//        vc.ID = ID
//        vc.Name = Name
//        vc.ParentID = ParentID
//        vc.ParentParentID = ParentParentID
//        self.present(vc, animated: true, completion: nil)
    }
    
    func sqlReading() throws {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fullPath = paths[0] as NSString
        let path = fullPath.appendingPathComponent("BegooPlus.db")
        let db = try Connection(path)
        for item in try db.prepare(table){
            if(Int(item[id_gr2])==ParentID && Int(item[vis1])==1 && Int(item[level])==lvl && Int(item[id_gr1])==ParentParentID){
                if let name = item[name1] {
                ID.append(Int(item[id_name]))
                guruhesh = item[gr2]!
                Name.append(name)
                }
            }
        }
    }
    

    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "BacktoPage4", sender: nil)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPage6"{
            if let vc = segue.destination as? Page6 {
                if let index = sender as? Int{
                    vc.currentIndex = index
                    vc.ID = ID
                    vc.Name = Name
                    vc.ParentID = ParentID
                    vc.ParentParentID = ParentParentID
                }
            }
        }
        if segue.identifier == "BacktoPage4"{
            if let vc = segue.destination as? Page4 {
                vc.ParentID = ParentParentID
            }

        }
    }

    
    
}
