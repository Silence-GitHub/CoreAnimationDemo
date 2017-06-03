//
//  BoatWaveView.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/6/2.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

private let kBoatImageViewSize: CGSize = CGSize(width: 20, height: 20)

class BoatWaveView: UIView {

    private var waveLayer: CAShapeLayer!
    private var currentPhase: CGFloat = 0
    private var waveLink: CADisplayLink?
    private var boatImageView: UIImageView!
    
    var isAnimating: Bool {
        return waveLink?.isPaused == false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waveLink?.invalidate()
    }
    
    private func setup() {
        backgroundColor = .yellow
        waveLayer = CAShapeLayer()
        waveLayer.frame = bounds
        waveLayer.fillColor = UIColor.white.cgColor
        waveLayer.strokeColor = UIColor.blue.cgColor
        layer.addSublayer(waveLayer)
        
        boatImageView = UIImageView(image: #imageLiteral(resourceName: "Boat"))
        boatImageView.frame = CGRect(origin: CGPoint(x: bounds.midX - kBoatImageViewSize.width / 2,
                                                     y: bounds.midY - kBoatImageViewSize.height),
                                     size: kBoatImageViewSize)
        addSubview(boatImageView)
    }
    
    @objc private func waveLinkRefresh() {
        let totalWidth: CGFloat = bounds.width
        let totalHeight: CGFloat = bounds.height
        let cycleCount: CGFloat = 0.5
        UIGraphicsBeginImageContext(CGSize(width: totalWidth, height: totalHeight))
        
        func angleInRadians(at x: CGFloat) -> CGFloat {
            return x / totalWidth * (CGFloat.pi * 2 * cycleCount)
        }
        
        func point(at i: Int) -> CGPoint {
            let x = CGFloat(i)
            let angle = angleInRadians(at: x)
            return CGPoint(x: x, y: (1 - sin(angle + currentPhase)) * totalHeight / 2)
        }
        
        let path = UIBezierPath()
        path.move(to: point(at: 0))
        for i in 1...Int(totalWidth) {
            path.addLine(to: point(at: i))
        }
        path.stroke()
        waveLayer.path = path.cgPath
        
        UIGraphicsEndImageContext()
        
        let centerX = totalWidth / 2
        let bottomCenter = point(at: Int(centerX))
        var transform: CGAffineTransform = .identity
        transform = transform.translatedBy(x: 0, y: bottomCenter.y - bounds.midY)
        let angle = angleInRadians(at: centerX)
        let tanValue = -totalHeight / 2 * cos(angle + currentPhase) * angleInRadians(at: 1) // Derivative of y
        transform = transform.rotated(by: atan(tanValue))
        boatImageView.transform = transform
        
        currentPhase += 0.05
    }
    
    override func didMoveToSuperview() {
        if superview == nil {
            waveLink?.invalidate()
        } else {
            waveLink = CADisplayLink(target: self, selector: #selector(waveLinkRefresh))
            waveLink?.isPaused = true
            waveLink?.add(to: .current, forMode: .defaultRunLoopMode)
        }
    }
    
    func start() {
        waveLink?.isPaused = false
    }
    
    func stop() {
        waveLink?.isPaused = true
    }

}
