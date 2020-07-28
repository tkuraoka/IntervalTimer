//
//  CountDownViewController.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/06/18.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController,CAAnimationDelegate {
    
    @IBOutlet weak var countLabel: UILabel!

    var timer_sec: Int = 3
    
    // 処理を何度も走らせないため
    var isBack:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        countLabel.text = String(self.timer_sec)
        
        // タイマーの作動
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(count), userInfo: nil, repeats: true)
        
    }

    @objc func count(_ timer: Timer) {
        // 処理内容
        if timer_sec > 1 {
        self.timer_sec -= 1
        self.countLabel.text = String(self.timer_sec)
        } else {
            if isBack {
                let vc = self.presentingViewController as! IntervalViewController
                vc.calledWhenModalDismisses()
                dismiss(animated: true, completion: nil)
                isBack = false
            }
        }
    }

}
