//
//  SettingsCell.swift
//  Begoo
//
//  Created by Soroush Shahi on 6/28/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit

class TreeVCCell: UITableViewCell {
    
    @IBOutlet weak var lbl : UILabel!
    
    @IBOutlet weak var indentation: NSLayoutConstraint!
    
    
    @IBOutlet weak var plus : UIImageView!
    
    @IBOutlet weak var minus : UIImageView!
    
    @IBOutlet weak var visOrNotSwitch : UISwitch!
    
    
    var indexPath : IndexPath!
    var values : [Int]!
    var key : String!
    var INDENTATIONCONST = 20
   // var deleted : [String] = []
    var type : Bool!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutMargins.left = CGFloat(self.indentationLevel) * self.indentationWidth
        self.contentView.layoutIfNeeded()
    }
    
    
    func configureCell (indexPath : IndexPath , key : String , values : [Int] , type : Bool) {
        self.indexPath = indexPath
        self.values = values
        self.key = key
        self.type = type
        
        self.indentation.constant = CGFloat(INDENTATIONCONST * values[1]) + 8
        self.lbl.text = key
        if values[1] == 3 {
            self.backgroundColor = UIColor(red: 174/255, green: 251/255, blue: 153/255, alpha: 0.3)
            self.visOrNotSwitch.isHidden = false
            self.accessoryType = .disclosureIndicator
        }
        else if values[1] == 1 {
            self.backgroundColor = UIColor(red: 174/255, green: 251/255, blue: 153/255, alpha: 1.0)
            self.visOrNotSwitch.isHidden = true
            self.accessoryType = .none
            
        }
            
        else if values[1] == 2 {
            self.backgroundColor = UIColor(red: 174/255, green: 251/255, blue: 153/255, alpha: 0.6)
            self.visOrNotSwitch.isHidden = false
            self.accessoryType = .none
            
        }
        else if values[1] == 0 {
            self.backgroundColor = UIColor(red: 30/255, green: 111/255, blue: 34/255, alpha: 0.7)
            self.visOrNotSwitch.isHidden = true
            self.accessoryType = .none
            
        }
        else {
            self.backgroundColor = UIColor.white
            self.visOrNotSwitch.isHidden = true
            self.accessoryType = .none
            
        }
        
        if values[2] == 0 && indexPath.row != 0 && values[1] != 3 {
            self.plus.isHidden = false
            self.minus.isHidden = true
        }
            
            
        else if values[2] == 1 && indexPath.row != 0 && values[1] != 3 {
            self.minus.isHidden = false
            self.plus.isHidden = true
            
        }
            
        else {
            self.minus.isHidden = true
            self.plus.isHidden = true
        }
        
        
        if self.type == false {
            
            
            if let deleted = UserDefaults.standard.value(forKey: "pro") as? [String] {
                for d in deleted {
                    if self.lbl.text! == d {
                        // print("\(self.lbl.text) --> is off")
                        self.visOrNotSwitch.isOn = false
                        break
                    }
                        
                    else {
                        //print("\(self.lbl.text) --> is on")
                        self.visOrNotSwitch.isOn = true
                    }
                }
                if deleted.count == 0 {
                    //print(lbl.text!)
                    self.visOrNotSwitch.isOn = true }
            }
            else {
                if self.type == false {
                    UserDefaults.standard.set(TreeVC.fundDeleted, forKey: "pro")}
                else{
                    UserDefaults.standard.set(TreeVC.proDeleted, forKey: "fund")
                }
                UserDefaults.standard.synchronize()
            }
        }
            
        else {
            
            if let deleted = UserDefaults.standard.value(forKey: "fund") as? [String] {
                for d in deleted {
                    //print("d is \(d) -- > text is \(self.lbl.text!)")
                    if self.lbl.text! == d {
                        // print("\(self.lbl.text) --> is off")
                        self.visOrNotSwitch.isOn = false
                        break
                    }
                        
                    else {
                        //print("\(self.lbl.text) --> is on")
                        self.visOrNotSwitch.isOn = true
                    }
                }
                if deleted.count == 0 {
                 //   print(lbl.text!)
                    self.visOrNotSwitch.isOn = true }
            }
            else {
                if self.type == false {
                    UserDefaults.standard.set(TreeVC.fundDeleted, forKey: "pro")}
                else{
                    UserDefaults.standard.set(TreeVC.proDeleted, forKey: "fund")
                }
                UserDefaults.standard.synchronize()
            }
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        self.selectionStyle = .none
        
        
        
        
        
    }
    
    
    @IBAction func switched (_ sender: Any){
        if visOrNotSwitch.isOn == true {
            if self.type == false {
                deleteItem(key: "pro", value: (self.lbl.text)!)
            }
            else {

                deleteItem(key: "fund", value: (self.lbl.text)!)}
            
            
            
            
        }
        else {
            //self.isUserInteractionEnabled = false
            //print("else")
            if self.type == false {
                //print(self.lbl.text!)
                TreeVC.proDeleted.append(self.lbl.text!)
                save()}
            else {
              //  print(self.lbl.text!)
                TreeVC.fundDeleted.append(self.lbl.text!)
                save()
            }
            let nc = NotificationCenter.default
            nc.post(name:Notification.Name(rawValue:"switchNotif"),
                    object: nil,
                    userInfo: ["indexPath" : indexPath])
            
            
        }
        
       // print(TreeVC.fundDeleted)
     //   print(TreeVC.proDeleted)
        
        
    }
    
    func save () {
        UserDefaults.standard.set(TreeVC.fundDeleted, forKey: "fund")
        UserDefaults.standard.set(TreeVC.proDeleted, forKey: "pro")
        UserDefaults.standard.synchronize()

    }
    
    func deleteItem (key : String , value : String) {
        
        if key == "fund" {
            
            for i in 0...TreeVC.fundDeleted.count - 1 {
                if TreeVC.fundDeleted[i] == value{
                    TreeVC.fundDeleted.remove(at: i)
                    
                    break
                }
            }
            
        }
        else {
            for i in 0...TreeVC.proDeleted.count - 1 {
                if TreeVC.proDeleted[i] == value{
                    TreeVC.proDeleted.remove(at: i)
                    break
                }
            }

        }
        UserDefaults.standard.set(TreeVC.fundDeleted, forKey: "fund")
        UserDefaults.standard.set(TreeVC.proDeleted, forKey: "pro")
        UserDefaults.standard.synchronize()
        
}
}
