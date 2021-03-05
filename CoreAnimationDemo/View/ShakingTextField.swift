//
//  ShakingTextField.swift
//  CoreAnimationDemo
//
//  Created by Alvin Tu on 3/5/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import UIKit

class ShakingTextField: UITextField {

    func shakeHorizontal() {
        let animation = CABasicAnimation(keyPath:"position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue =  NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue =  NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func shakeVertical() {
        let animation = CABasicAnimation(keyPath:"position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue =  NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y + 4))
        animation.toValue =  NSValue(cgPoint: CGPoint(x: self.center.x, y: self.center.y - 4))
        self.layer.add(animation, forKey: "position")
    }
    
    func shakeCrazy() {
        let offset: CGFloat = 20
        let duration: CFTimeInterval = 0.05
        let repeatCount: Float = 10.0

        let animation = CABasicAnimation(keyPath:"position")
        animation.duration = duration
        animation.repeatCount = repeatCount
        animation.autoreverses = true
        animation.fromValue =  NSValue(cgPoint: CGPoint(x: self.center.x + offset, y: self.center.y + offset))
        animation.toValue =  NSValue(cgPoint: CGPoint(x: self.center.x - offset, y: self.center.y - offset))
        self.layer.add(animation, forKey: "position")
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
