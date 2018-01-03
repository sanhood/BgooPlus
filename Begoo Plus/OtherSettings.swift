//
//  OtherSettings.swift
//  Begoo
//
//  Created by Danoosh Chamani on 7/7/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit

class OtherSettings: UIViewController ,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var Bluredview: UIView!
    @IBOutlet weak var BluredExit: UIButton!
    @IBOutlet weak var PickerTime: UIPickerView!
    @IBOutlet weak var PickerNum: UIPickerView!
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        PickerNum.delegate = self
        PickerTime.delegate = self
        PickerNum.dataSource = self
        PickerTime.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NumPressed(_ sender: Any) {
        Uplayer.play()
        PickerNum.isHidden = false
        BluredExit.isHidden = false
        Bluredview.isHidden = false
        
    }
    
    @IBAction func timePressed(_ sender: Any) {
        Uplayer.play()
        PickerTime.isHidden = false
        BluredExit.isHidden = false
        Bluredview.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PickerTime.isHidden = true
        PickerNum.isHidden = true
        Bluredview.isHidden = true
        BluredExit.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        PickerNum.selectRow(QuestionCount-5, inComponent: 0, animated: false)
        PickerTime.selectRow(Int(RecTime-5), inComponent: 0, animated: false)
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag==0 {
            return 7
            
        }else{
            return 11
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return String(2+row)
        }else{
            return String(5 + row)
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        timer.invalidate()
        if pickerView.tag==0{
            RecTime = Double(2 + row)
            UserDefaults.standard.setValue(RecTime, forKey: "RecTime")
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 0.8 , target: self, selector: #selector(self.hide), userInfo: nil, repeats: true)
                
            }

        }else if pickerView.tag==1{
            QuestionCount = 5 + row
            UserDefaults.standard.setValue(QuestionCount, forKey: "Qcount")
            DispatchQueue.main.async {
                self.timer = Timer.scheduledTimer(timeInterval: 0.8 , target: self, selector: #selector(self.hide), userInfo: nil, repeats: true)
                
            }
        }
        
    }
    
    func hide() {
        timer.invalidate()
        PickerTime.isHidden = true
        PickerNum.isHidden = true
        Bluredview.isHidden = true
        BluredExit.isHidden = true
    }
    
    @IBAction func ExitBlured(_ sender: Any) {
        Bluredview.isHidden = true
        PickerTime.isHidden = true
        PickerNum.isHidden = true
        BluredExit.isHidden = true
    }


}
