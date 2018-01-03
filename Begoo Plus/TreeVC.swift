//
//  SettingsVC.swift
//  Begoo
//
//  Created by Soroush Shahi on 6/28/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit

class TreeVC: UITableViewController {
    var fundamental : NSDictionary!
    var pro : NSDictionary!
    var currentDic : NSDictionary!
    var data : [String : [Int]] = ["مرحله مقدماتی" : [0,0,0,0]]
    var count = 0
    var cellDescriptors: NSMutableArray!
    var headers : [String] = []
    var level = 0
    var flag = false
    var id : [Int] = [0,0]
    var touchedLevel = 0
    var touchedParent = 0
    var touchedKey = ""
    var parents = 0
    static var fundDeleted : [String] = []
    static var proDeleted : [String] = []

    
    var switchFlag = true
    
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsMultipleSelectionDuringEditing = false;
        self.tableView.register(TreeVCCell.self, forCellReuseIdentifier: "reuseIdentifier")
        loadCellDescriptors()
        //  print(cellDescriptors.count)
        
        let nib = UINib(nibName: "TreeVCCell", bundle: nil)
        self.tableView.register(nib,forCellReuseIdentifier: "cell")
        
        fundamental = cellDescriptors[0] as! NSDictionary
        pro = cellDescriptors[1] as! NSDictionary
        
        currentDic = fundamental
        
        _ = NotificationCenter.default.addObserver(forName: Notification.Name(rawValue : "switchNotif"), object: nil, queue: nil, using: handleSwitch)
        
        if let pro = UserDefaults.standard.value(forKey: "pro") {
            TreeVC.proDeleted = pro as! [String]
        }
        else {
            UserDefaults.standard.set(TreeVC.proDeleted, forKey: "pro")        }
        
        if let fund = UserDefaults.standard.value(forKey: "fund") {
            TreeVC.fundDeleted = fund as! [String]
        }
        else {
            UserDefaults.standard.set(TreeVC.fundDeleted, forKey: "fund")
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated : Bool) {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return []
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("selected")
        
        
        
        let indexP = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexP!) as! TreeVCCell
        if currentCell.visOrNotSwitch.isOn == false && switchFlag {
            switchFlag = true
          //  print("return")
            return
        }
        switchFlag = true
        
        
        
        if indexPath.row == 0 {
            data.removeAll()
            if currentDic == fundamental {
                data["مرحله مقدماتی"] = [0,0,0,0]
            }
            else {
                data["مرحله پیشرفته"] = [0,0,0,0]
            }
            data["یادگیری"] = [1,1,0,100]
            
            //data["آزمون"] = [2,1,0,100]
            self.tableView.reloadSections((NSIndexSet(index: indexPath.section)) as IndexSet, with: .fade)
            //self.tableView.reloadData()
            
        }
        else{
            findRequirements(indexPath : indexPath)
            
            if touchedLevel != 3 {
                if flag{
                    collapse(indexPath: indexPath)
                }
                    
                else {
                    collide(indexPath: indexPath)
                }
                
            }
                
            else {
                findIDOfKey(key: touchedKey, inDic: currentDic)
                performSegue(withIdentifier: "words", sender: nil)
            }
            if indexPath.row == 1 && data["یادگیری"]?[2] == 0 {
                let temp = data["یادگیری"]!
                data.removeAll()
                if currentDic == fundamental {
                    data["مرحله مقدماتی"] = [0,0,0,0]
                    data["یادگیری"] = [1,temp[1],temp[2],temp[3]]
                }
                else{
                    data["مرحله پیشرفته"] = [0,0,0,0]
                    
                }
            }
            self.tableView.reloadSections((NSIndexSet(index: indexPath.section)) as IndexSet, with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "words"{
            let dest = segue.destination as! WordsVC
            dest.id_id = id
        }
        
    }
    
    
    
    
    
    func loadCellDescriptors() {
        if let path = Bundle.main.path(forResource: "Settings", ofType: "plist") {
            cellDescriptors = NSMutableArray(contentsOfFile: path)
        }
    }
    
    func findRequirements (indexPath : IndexPath) {
        parents = 0
        for item in data {
            if item.value[0] == indexPath.row{
                touchedLevel = item.value[1]
                touchedParent = item.value[3]
                parents = indexPath.row
                touchedKey = item.key
                if touchedLevel == 3 {
                    data[item.key] = [item.value[0] , item.value[1] , 0 , item.value[3]]
                    flag = false
                }
                else if item.value[2] == 0{
                  //  print("\(item.key)==1")
                    flag = true
                    data[item.key] = [item.value[0] , item.value[1] , 1 , item.value[3]]}
                else{
                  //  print("\(item.key)==0")
                    flag = false
                    data[item.key] = [item.value[0] , item.value[1] , 0 , item.value[3]]
                }
                //print("item key is \(item.key)")
                if touchedLevel != 3 {
                    findContentsOfKey(key: item.key, inDic: currentDic)
                    findLevelOfKey(key: item.key, inDic: currentDic)}
                //print("level is \(level)")
            }
        }
    }
    
    
    
    
    
    //    func findReoccurenceOfKey (key : String , inDic : NSDictionary) -> Int {
    //        if inDic == nil {
    //            return 0
    //        }
    //        for kilid in inDic.allKeys {
    //
    //            //print(kilid)
    //
    //            if (kilid as? String) == "isVisible" {
    //                if (inDic["isVisible"] as! Bool) == true{
    //                    count = count + 1}
    //
    //            }
    //            else if (kilid as? String) != "level" {
    //               findReoccurenceOfKey(key: key, inDic: inDic[kilid] as! NSDictionary)
    //            }
    //
    //        }
    //
    //        return count
    //    }
    
    
    func findContentsOfKey (key : String , inDic : NSDictionary) {
        
        
        
        for kilid in inDic.allKeys {
            //print("\(kilid) ---> \(key)")
            if kilid as? String == key {
                let temp0 = inDic.value(forKey: key) as! NSDictionary
                
                let temp1 = temp0.value(forKey: "contents") as! NSDictionary
                headers = temp1.allKeys as! [String]
                
            }
                
            else if kilid as? String != "isVisible" && kilid as? String != "level" &&   kilid as? String != "id-gr1" && kilid as? String != "id-gr2"{
                findContentsOfKey(key: key, inDic: inDic[kilid] as! NSDictionary)
            }
        }
    }
    
    func findLevelOfKey (key : String , inDic : NSDictionary) {
        
        for kilid in inDic.allKeys {
            // print(kilid)
            
            if kilid as? String == key {
                let temp0 = inDic.value(forKey: key) as! NSDictionary
                level = temp0.value(forKey: "level") as! Int
                
                
            }
                
            else if kilid as? String == "contents"{
                findLevelOfKey(key: key, inDic: inDic["contents"] as! NSDictionary)
            }
                
            else if kilid as? String != "isVisible" && kilid as? String != "level" && kilid as? String != "contents" && kilid as? String != "id-gr1" && kilid as? String != "id-gr2" {
                
                findLevelOfKey(key: key, inDic: inDic[kilid] as! NSDictionary)
            }
            
        }
    }
    
    
    func findIDOfKey (key: String , inDic : NSDictionary) {
        
        for kilid in inDic.allKeys {
            // print(kilid)
            if kilid as? String == key {
                let temp0 = inDic.value(forKey: key) as! NSDictionary
                id[0] = temp0.value(forKey: "id-gr1") as! Int
                id[1] = temp0.value(forKey: "id-gr2") as! Int
            }
                
            else if kilid as? String == "contents" {
                //  print((inDic["contents"] as! NSDictionary).allKeys)
                findIDOfKey(key: key, inDic: inDic["contents"] as! NSDictionary)
            }
                
            else if kilid as? String != "isVisible" && kilid as? String != "level" && kilid as? String != "contents" && kilid as? String != "id-gr1" && kilid as? String != "id-gr2" {
                
                findIDOfKey(key: key, inDic: inDic[kilid] as! NSDictionary)
            }
            
            
        }
        
    }
    
    
    
    func collide (indexPath : IndexPath) {
      //  print("collide")
        for d in data {
            if d.value[0] == indexPath.row{
                let parent = indexPath.row
                //  print("d is \(d.key)")
                for da in data{
                    if  d.value[1] < da.value[1] && da.value[3] == parent{
                        
                        // print("da is \(da.key)")
                        data.removeValue(forKey: da.key)
                        //print("removing lower levels \(data)")
                        for dat in data{
                            if dat.value[0] > indexPath.row{
                                //print("upping \(data)")
                                
                                data.updateValue([dat.value[0] - 1 , dat.value[1] , dat.value[2] , dat.value[3]], forKey: dat.key)
                                
                                if dat.value[3] != indexPath.row && dat.value[1] >= touchedLevel && dat.value[3] != touchedParent {
                                    data.updateValue([dat.value[0] - 1 , dat.value[1] , dat.value[2] , dat.value[3] - 1], forKey: dat.key)
                                }
                                
                                
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    func collapse (indexPath : IndexPath) {
        
        for head in headers {
            var counter = 1
            for d in data{
                if d.value[0] > indexPath.row {
                    //print(d.value[0])
                    data.updateValue([d.value[0] + 1 , d.value[1] , d.value[2] , d.value[3]], forKey: d.key)
                    
                    if d.value[1] >= touchedLevel && d.value[3] != indexPath.row && d.value[3] != touchedParent  {
                        data.updateValue([d.value[0] + 1 , d.value[1] , d.value[2] , d.value[3] + 1], forKey: d.key)
                    }
                    // print("key is \(d.key) value is \(data[d.key])")
                }
                // print("end of for")
            }
            data[head] = [indexPath.row + counter, level + 1, 0 , parents]
            //  print("this was added. key is \(head) value is \(data[head])")
            counter += 1
            
        }
        
    }
    
    
    func handleSwitch (notif : Notification) -> Void {
        // print(notif.userInfo)
        let temp = notif.userInfo?["indexPath"] as! IndexPath
        //findRequirements(indexPath: temp)
        tableView.selectRow(at: temp, animated: true, scrollPosition: .none)
        
        
        for d in data {
           // print("d.value[0] is \(d.value[0]) and d.value[2] is \(d.value[2])")
            if d.value[0] == temp.row && d.value[2] == 1 {
                switchFlag = false
                tableView.delegate?.tableView!(tableView, didSelectRowAt: temp)
            }
        }
        
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TreeVCCell
        
        
        
        
        for d in data {
            //print("d key is \(d.key) ->> d value[1] is \(d.value[1])")
            if d.value[0] == indexPath.row{
                if currentDic == fundamental {
                    cell.configureCell(indexPath: indexPath, key: d.key , values: d.value, type: true)
                }
                else {
                    cell.configureCell(indexPath: indexPath, key: d.key , values: d.value, type: false)
                }
                
                
                
            }
            
            
            
            
        }
        
        
        
        return cell
    }
    
    
    
    
    
    
    
    
    
}
