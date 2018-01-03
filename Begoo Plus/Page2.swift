//
//  Page2.swift
//  Begoo
//
//  Created by Danoosh Chamani on 6/27/17.
//  Copyright © 2017 Axaan. All rights reserved.
//

import UIKit

class Page2: UIViewController {
    @IBOutlet weak var ViewofBtns:UIView!
    var Size = CGRect()
    override func viewDidLoad() {
        super.viewDidLoad()
        Lbl1=""
        Lbl2=""
        Lbl3=""
        Size = CGRect(x: screenSize.minX, y: screenSize.midY+55, width: screenSize.width, height: screenSize.height-55)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool){
        let Btn1 = UIButton()
        let Btn2 = UIButton()
        Btn1.tag = 0
        Btn2.tag = 1
        Btn1.setImage(UIImage(named: "amozesh"), for: .normal)
        Btn2.setImage(UIImage(named: "azmon"), for: .normal)
        Btn1.imageView?.contentMode = .scaleAspectFit
        Btn2.imageView?.contentMode = .scaleAspectFit
        Btn1.backgroundColor = UIColor.white
        Btn2.backgroundColor = UIColor.white
        Btn1.addTarget(self, action: #selector(BtnPressed), for: .touchUpInside)
        Btn2.addTarget(self, action: #selector(BtnPressed), for: .touchUpInside)
        Btn1.translatesAutoresizingMaskIntoConstraints = false
        Btn2.translatesAutoresizingMaskIntoConstraints = false
        ViewofBtns.addSubview(Btn1)
        ViewofBtns.addSubview(Btn2)
        let pintop = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let pinleft = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let pinright = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: Btn1, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (Size.height/2)-1)
        ViewofBtns.addConstraints([pintop,pinleft,pinright,height])
        let pinbtm2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let pinleft2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let pinright2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: ViewofBtns, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let height2 = NSLayoutConstraint(item: Btn2, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: (Size.height/2)-1)
        ViewofBtns.addConstraints([pinbtm2,pinleft2,pinright2,height2])
    }

    
    func BtnPressed(sender: UIButton!) {
        Uplayer.play()
        if (sender.tag == 0){
            Amoozesh = true
        }else{
            Amoozesh = false
        }
        performSegue(withIdentifier: "toPage3", sender: nil)
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
