//
//  TimeChangeModel.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/06/22.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import Foundation

class ToMinChange {
    
    var min = 0
    var sec = 0
    var totalSec = 0
    
    // 秒から分秒に変換
    func minChange () {
        min = totalSec / 60
        sec = totalSec % 60
    }
    
}
