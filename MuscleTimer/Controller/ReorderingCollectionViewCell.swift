//
//  ReorderingCollectionViewCell.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/05/29.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import UIKit

class ReorderingCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    
    // タップされたときのアニメーションをつける
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                print("タップ")
                let shrink = CABasicAnimation(keyPath: "transform.scale")
                // アニメーションの間隔
                shrink.duration = 0.1
                shrink.fromValue = 1.0
                shrink.toValue = 0.95
                // 自動で戻るか
                shrink.autoreverses = false
                shrink.repeatCount = 1
                // アニメーションが終了した状態を維持する
                shrink.isRemovedOnCompletion = false
                shrink.fillMode = CAMediaTimingFillMode.forwards
                self.layer.add(shrink, forKey: "shrink")
            } else {
//                print("タップっぷ")
//                let shrink = CABasicAnimation(keyPath: "transform.scale")
//                shrink.duration = 0.2
//                shrink.fromValue = 0.2
//                shrink.toValue = 0.95
//                shrink.autoreverses = false
//                shrink.repeatCount = 1
//                shrink.isRemovedOnCompletion = false
//                self.layer.add(shrink, forKey: "shrink")
            }
        }
    }
}
