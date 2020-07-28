//
//  Toast.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/07/02.
//  Copyright © 2020 Takashi Kuraoka. All rights reserved.
//

import UIKit
 

class Toast {
    internal static func show(_ text: String, _ parent: UIView) {
        let label = UILabel()
        let width = parent.frame.size.width / 1.2
        let height = parent.frame.size.height / 15
        
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textColor = UIColor.white
        label.textAlignment = .center;
        label.text = text
        label.layer.cornerRadius = 10.0
        label.clipsToBounds = true
        
        label.frame = CGRect(x: parent.frame.size.width / 2 - (width / 2), y: 50, width: width, height: height)
        parent.addSubview(label)
        
        UIView.animate(withDuration: 1.0, delay: 3.0, options: .curveEaseOut, animations: {
            label.alpha = 0.0
        }, completion: { _ in
            label.removeFromSuperview()
        })
        
    }
    
    
}
