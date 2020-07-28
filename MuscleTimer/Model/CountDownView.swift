//
//  CountDownViewModel.swift
//  MuscleTimer
//
//  Created by 倉岡隆志 on 2020/05/30.
//  Copyright © 2020 倉岡隆志. All rights reserved.
//

import UIKit

@objc protocol CountDownDelegate {
    func didCount(count: Int)
    func didFinish()
}

class CountDownView: UIView, CAAnimationDelegate {
    
    weak var delegate: CountDownDelegate?
    
    var shapeLayer = CAShapeLayer()
    var label = UILabel()
    var max = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let lineWidth:CGFloat = 10.0
        let lineColor = UIColor.black
        
        label.frame = CGRect(x: 0,y: 0, width: frame.width, height: frame.height)
        label.center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 100)
        label.backgroundColor = .lightGray
        addSubview(label)
        
        shapeLayer.isHidden = true
        label.isHidden = true
        shapeLayer.frame = CGRect(x: 0,y: 0, width: frame.width, height: frame.height)
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
        

        
    }
    
    func start(max:Int){
        print("DEBUG: スタート(CountDownクラス)")
        print(max)
        self.max = max
        shapeLayer.isHidden = false
        label.isHidden = false
        label.text = "\(max)"
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1.0
        animation.fromValue = 10.0
        animation.toValue = 0.0
        animation.delegate = self
        shapeLayer.add(animation, forKey: "circleAnim")
    }
    
    func stop(){
        print("DEBUG: ストップ(CountDownクラス)")
        shapeLayer.isHidden = true
        shapeLayer.removeAnimation(forKey: "circleAnim")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            if 1 < max {
                start(max: max - 1)
                delegate?.didCount(count: max)
                print("DEBUG: 残りカウント\(max)")
                return
            }
        }
        delegate?.didFinish()
        shapeLayer.isHidden = true
        label.isHidden = true
    }
}
