//
//  SetTimer.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/05/29.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import Foundation
import RealmSwift

class SetTimer : Object {
    // 管理用id
    @objc dynamic var id: Int = 0
    @objc dynamic var timerName: String = ""
    @objc dynamic var onTime: Int = 0
    @objc dynamic var offTime: Int = 0
    @objc dynamic var setCount: Int = 1
    
    
    
    var order = RealmOptional<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
