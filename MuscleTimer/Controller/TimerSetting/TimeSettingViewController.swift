//
//  TimeSettingViewController.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/06/26.
//  Copyright © 2020 Takashi Kuraoka. All rights reserved.
//

import UIKit


class TimeSettingViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var min:Int = 0
    var sec:Int = 0
    
    var whichTimer = ""
    
    @IBOutlet weak var navigationTitle: UINavigationBar!
    
    @IBOutlet weak var naviTitle: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("DEBUG_PRINT: \(min)")
        print("DEBUG_PRINT: \(sec)")
        
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        // Pickerの初期値
        pickerView.selectRow(min, inComponent: 0, animated: true)
        pickerView.selectRow(sec, inComponent: 2, animated: true)
        
        switch whichTimer {
        case "onTimer":
            return naviTitle.title = "運動時間の設定"
            
        case "offTimer":
            return naviTitle.title = "休憩時間の設定"
        default:
            break
        }
        
    }

}

extension TimeSettingViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    // componentの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 60
        case 1:
            return 1
        case 2:
            return 60
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        switch component {
        case 0:
            min = row
        case 2:
            sec = row
        default:
            break
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "min"
        case 2:
            return "\(row)"
        case 3:
            return "sec"
        default:
            return ""
        }
        return ""
    }


    //    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    //        print("DEBUG_PRINT: numberOfRowsIn")
    //        print(component)
    //        switch component {
    //        case 0:
    //            return 60
    //        case 1:
    //            return 1
    //        case 2:
    //            return 60
    //        case 3:
    //            return 1
    //        default:
    //            return 1
    //        }
    //    }
    
}

extension TimeSettingViewController: UIPickerViewDelegate {
    
}
