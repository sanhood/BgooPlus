//
//  ResultsVC.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/29/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit

class ResultsVC: UIViewController,UITableViewDelegate,UITableViewDataSource{
    let reuseID = "Cell"

    @IBOutlet weak var Tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Tableview.delegate=self
        Tableview.dataSource=self

        let nib = UINib(nibName: "ResultCell", bundle: nil)
        Tableview.register(nib, forCellReuseIdentifier: reuseID)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Tableview.allowsSelection = false
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ResultCell = self.Tableview.dequeueReusableCell(withIdentifier: reuseID)! as! ResultCell
        cell.Date.text = Results[indexPath.row]["Date"] as? String
        cell.Count.text = String(describing: Results[indexPath.row]["Count"]!)
        cell.Correct.text = String(describing: Results[indexPath.row]["Correct"]!)
        cell.Wrong.text = String(describing: Results[indexPath.row]["Wrong"]!)
        cell.Percentage.text = String(describing: Results[indexPath.row]["Percentage"]!)
        return cell
    }
    
    @IBAction func Clear(_ sender: Any) {
        let message="آیا مایل به پاک کردن نتایج تمامی آزمون ها هستید؟"
        let alert = UIAlertController(title: "پیام", message: message, preferredStyle: .alert)
        let no = UIAlertAction(title: "خیر", style: .default , handler: nil)
        let yes = UIAlertAction(title: "بله", style: .default , handler: { void in
            Results.removeAll()
            UserDefaults.standard.removeObject(forKey: "Results")
            self.Tableview.reloadData()
        })
        alert.addAction(no)
        alert.addAction(yes)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
