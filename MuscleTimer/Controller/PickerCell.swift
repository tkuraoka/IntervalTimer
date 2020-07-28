//
//  PickerCell.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/06/25.
//  Copyright © 2020 Takashi Kuraoka. All rights reserved.
//

import UIKit

class PickerCell: UITableViewCell,UIPickerViewDelegate,UIPickerViewDataSource {

    

    

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    @IBOutlet weak var setLabel: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print("DEBUG_PRINT: PickerCellが押されました")
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("DEBUG_PRINT: numberOfRowsIn")
        print(component)
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
            return 1
        }
    }

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
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
    }

    
}
