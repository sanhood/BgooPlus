//
//  AfterTest.swift
//  Begoo
//
//  Created by Danoosh Chamani on 7/5/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit

class AfterTest: UIViewController {
    @IBOutlet weak var CorrectLbl: UILabel!
    @IBOutlet weak var WrongLbl: UILabel!
    @IBOutlet weak var AllLbl: UILabel!
    @IBOutlet weak var PrecenLbl: UILabel!
    var correct=0
    var wrong=0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PrecenLbl.layer.masksToBounds = true
        PrecenLbl.layer.cornerRadius = CGFloat(155/2)
        CorrectLbl.text = String(correct)
        WrongLbl.text = String(wrong)
        AllLbl.text = String(QuestionCount)
        PrecenLbl.text = "%" + String(format: "%.1f", Float((Double(correct)/Double(QuestionCount))*100))
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
