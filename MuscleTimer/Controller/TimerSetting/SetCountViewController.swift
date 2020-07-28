//
//  SetCountViewController.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/06/27.
//  Copyright © 2020 Takashi Kuraoka. All rights reserved.
//

import UIKit

class SetCountViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var setCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Pickerの初期値
        var setRow = setCount - 1
        pickerView.selectRow(setRow, inComponent: 0, animated: true)
    }

}

extension SetCountViewController: UIPickerViewDataSource {
    // 列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 99
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.setCount = row + 1
        return "\(setCount)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return setCount = row + 1
    }
}
extension SetCountViewController: UIPickerViewDelegate {
    
}
