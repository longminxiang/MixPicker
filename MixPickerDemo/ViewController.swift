//
//  ViewController.swift
//  MixPickerDemo
//
//  Created by Eric Lung on 2017/5/31.
//  Copyright © 2017年 Eric Lung. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func buttonTouched() {
//        self.view.mixPickerManager.show = true
//        
//        let picker = self.view.mixPickerManager.picker;
//        picker?.columnElements = [["111" as NSString, "222" as NSString, "333" as NSString, "444" as NSString], ["111" as NSString, "222" as NSString, "333" as NSString, "444" as NSString], ["111" as NSString, "222" as NSString, "333" as NSString, "666" as NSString]];
        
        self.view.mixDatePickerManager.show = true;
        let picker = self.view.mixDatePickerManager.picker;
        picker.date = Date()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

