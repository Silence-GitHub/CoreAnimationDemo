//
//  CircleProgressVC.swift
//  CoreAnimationDemo
//
//  Created by Alvin Tu on 3/5/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import UIKit

class CircleProgressVC: UIViewController {
    
    let circleShapeLayer = CAShapeLayer()
    let rectangleShapeLayer = CAShapeLayer()
    let ovalShapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        addRectangle()
        addCircle()
        addOval()
        

    }
    
    private func addRectangle() {
        
        let rentangularPath = UIBezierPath(roundedRect: CGRect(x: 105,
                                                               y: 85,
                                                               width: 100  ,
                                                               height: 100),
                                           byRoundingCorners: .allCorners,
                                           cornerRadii: CGSize(width: 30, height: 30))

        rectangleShapeLayer.path = rentangularPath.cgPath
        rectangleShapeLayer.fillColor = UIColor.cyan.cgColor
        
        rectangleShapeLayer.strokeColor = UIColor.systemGray.cgColor
        rectangleShapeLayer.lineWidth = 10
        rectangleShapeLayer.strokeEnd = 0
        view.layer.addSublayer(rectangleShapeLayer)


    }
    
    private func addCircle() {
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center,
                                        radius: 100, startAngle: 0,
                                        endAngle: 2 * CGFloat.pi,
                                        clockwise: true)
        
        
        circleShapeLayer.path = circularPath.cgPath
        circleShapeLayer.fillColor = UIColor.blue.cgColor
        circleShapeLayer.strokeColor = UIColor.red.cgColor
        circleShapeLayer.lineWidth = 10
        circleShapeLayer.strokeEnd = 0
        view.layer.addSublayer(circleShapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))

        
    }
    private func addOval(){
        
        let ovalPath = UIBezierPath(ovalIn: CGRect  (x: 120,
                                                 y: 390,
                                                 width: 80  ,
                                                 height: 150))
        ovalShapeLayer.path = ovalPath.cgPath
        ovalShapeLayer.fillColor = UIColor.systemGreen.cgColor
        ovalShapeLayer.strokeColor = UIColor.black.cgColor
        ovalShapeLayer.lineWidth = 30
        ovalShapeLayer.strokeEnd = 0
        view.layer.addSublayer(ovalShapeLayer)

    }
    
    
    @objc func handleTap(){
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        circleShapeLayer.add(basicAnimation, forKey: "circleDraw")
        rectangleShapeLayer.add(basicAnimation, forKey: "retangleDraw")
        ovalShapeLayer.add(basicAnimation, forKey: "ovalDraw")

        
    }
}
