//
//  IntervalTimer.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/05/31.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import UIKit

@objc protocol IntervalDelegate {
    func didCount(count: Int)
    func didFinish()
}

class IntervalTimerView: UIView, CAAnimationDelegate {
    
    weak var delegate: IntervalDelegate?
    
    var shapeLayer = CAShapeLayer()
    var label = UILabel()
    var max = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        let lineWidth:CGFloat = 10.0
        let lineColor = UIColor.red
        
        shapeLayer.isHidden = true
        label.isHidden = true
        shapeLayer.frame = CGRect(x: 0,y: 0, width: frame.width, height: frame.height)
        // fill = 埋める
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        
        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let redius = bounds.size.width / 2 - lineWidth / 2
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = startAngle + 2.0 * CGFloat(M_PI)
        let path = UIBezierPath(arcCenter: center, radius: redius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        
        label.frame = CGRect(x: 0,y: 0, width: frame.width, height: frame.height)
        label.center = CGPoint(x: bounds.size.width, y: bounds.size.height / 2.0)
        label.font = UIFont.boldSystemFont(ofSize: 100)
        addSubview(label)
        
        
    }
    
    func start(max: Int){
        self.max = max
        shapeLayer.isHidden = false
        label.text = "\(max)"
        
    }
    
}
