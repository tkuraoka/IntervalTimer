//
//  TimerNameViewController.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/06/26.
//  Copyright © 2020 Takashi Kuraoka. All rights reserved.
//

import UIKit

class TimerNameViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    var timerName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.text = timerName
    }
    
}


