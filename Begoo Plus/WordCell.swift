//
//  WordCell.swift
//  Begoo
//
//  Created by Soroush Shahi on 6/30/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit
import SQLite

class WordCell: UITableViewCell {
    
    @IBOutlet weak var lbl : UILabel!
    
    var myID : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell (text : String , id : Int, deleted : [Int]) {
        lbl.text = text
        myID = id
        if deleted.contains(myID){
            self.accessoryType = .none
        }
        else{
            self.accessoryType = .checkmark
        }
        //        do {
        //        if try isVisOrNot()  {
        //
        //            self.accessoryType = .checkmark
        //        }
        //        else{
        //            self.accessoryType = .none
        //            }
        //        }
        //        catch{}
    }
    
    //    func isVisOrNot() throws -> Bool {
    //        let db = try Connection(path!, readonly: true)
    //        for item in try db.prepare(table){
    //           // print(myID)
    //            if(Int(item[id]) == myID){
    //                print(item[vis1])
    //                if(Int(item[vis1]) == 1){
    //                    //print("true")
    //                    return true}
    //                else {
    //                   // print("false")
    //                    return false
    //                }
    //            }
    //        }
    //      return false
    //    }
    
    
    
}
