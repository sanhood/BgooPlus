//
//  WordsVC.swift
//  Begoo
//
//  Created by Soroush Shahi on 6/29/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import SQLite

class WordsVC: UITableViewController {
    
    var id_id = [0,0]
    
    var ID_name : [Int] = []
    var names : [String] = []
    var deleted : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do { try sqlReading() }
        catch {}
        // print(id)
        let nib = UINib(nibName: "WordCell", bundle: nil)
        self.tableView.register(nib,forCellReuseIdentifier: "wordcell")
        //print(deleted)
        // print(names)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return names.count
    }
    
    
    
    
    func sqlReading() throws {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fullPath = paths[0] as NSString
        let path = fullPath.appendingPathComponent("BegooPlus.db")
        let db = try Connection(path)
        for item in try db.prepare(table){
            if(Int(item[id_gr2])==id_id[1] && Int(item[id_gr1])==id_id[0]){
                ID_name.append(Int(item[id]))
                if let name = item[name1] {
                    names.append(name)
                }
                
            }
            
            if (Int(item[vis1]) == 0) {
                deleted.append(Int(item[id]))
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordcell", for: indexPath) as! WordCell
        cell.configureCell(text: names[indexPath.row] , id : ID_name[indexPath.row], deleted: deleted)
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var flag = false
        if deleted.count != 0 {
            do {
                for i in 0...deleted.count - 1 {
                    if deleted[i] == ID_name[indexPath.row] {
                        deleted.remove(at: i)
                        
                        try changingDB(idid: ID_name[indexPath.row], value: 1)
                        flag = true
                        break
                        // try check(idid : ID_name[indexPath.row])
                        
                    }
                        
                    
                    
                }
                if !flag {
                    deleted.append(ID_name[indexPath.row])
                    try changingDB(idid: ID_name[indexPath.row], value: 0)
                }
                
            }
            catch {}
            
        }
        else {
            do{
                deleted.append(ID_name[indexPath.row])
                try changingDB(idid: ID_name[indexPath.row], value: 0)
            }
            catch {
                
            }
        }
        
        
        //tableView.visibleCells[indexPath.row].accessoryType = .checkmark
        tableView.reloadData()
    }
    
    
    @IBAction func dismiss (_ sender : Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func changingDB(idid : Int , value : Int) throws{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fullPath = paths[0] as NSString
        let path = fullPath.appendingPathComponent("BegooPlus.db")
        let db = try Connection(path)
        _ = try db.prepare(table)
        
        let alice = table.filter(id == Int64(idid)) //alice is table of all rows that which have id_gr1=1
        try db.transaction {
            try db.run(alice.update(vis1<-Int64(value)))
        }
        
    }
    
    
    func check(idid : Int) throws{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let fullPath = paths[0] as NSString
        let path = fullPath.appendingPathComponent("BegooPlus.db")
        let db = try Connection(path, readonly: true)
        for item in try db.prepare(table){
            if(item[id] == Int64(idid)){
                // print(item[vis1])
            }
        }
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
