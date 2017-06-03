//
//  BoatWaveView.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/6/2.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

private let kBoatImageViewSize: CGSize = CGSize(width: 20, height: 20)
private let PI_Circle: CGFloat = CGFloat.pi * 2

class BoatWaveView: UIView {

    /**
     Wave move step.
     A positive value specifies right movement, a negative value specifies left movement.
     This value should NOT be 0.
     */
    var step: CGFloat = 0.05 {
        didSet {
            assert(step != 0, "Step (\(step)) must != 0")
        }
    }
    
    /**
     Number of wave cycle the view can display each time.
     This value should be greater than or equal to 0.
     */
    var cycleCount: CGFloat = 0.5 {
        didSet {
            assert(cycleCount >= 0, "Cycle count (\(cycleCount)) must >= 0")
        }
    }
    
    var minWaterDepth: CGFloat = 20 {
        didSet {
            assert(minWaterDepth > 0, "Min water depth (\(minWaterDepth)) must > 0")
        }
    }
    
    private var boatImageView: UIImageView!
    private var skyLayer: CALayer!
    private var waveLayer: CAShapeLayer!
    private var underWaveLayer: CALayer!
    private var currentPhase: CGFloat = 0
    private var waveLink: CADisplayLink?
    
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
        NotificationCenter.default.removeObserver(self)
        waveLink?.invalidate()
    }
    
    private func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(stop), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(start), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
        
        let sky = CAGradientLayer()
        sky.frame = bounds
        sky.colors = [UIColor(red: 0.663, green: 0.812, blue: 0.961, alpha: 1).cgColor,
                      UIColor.white.cgColor]
        layer.addSublayer(sky)
        skyLayer = sky
        
        let underWave = CAGradientLayer()
        underWave.frame = bounds
        underWave.colors = [UIColor(red: 0.471, green: 0.784, blue: 1.000, alpha: 1).cgColor,
                            UIColor(red: 0.122, green: 0.365, blue: 0.788, alpha: 1).cgColor]
        layer.addSublayer(underWave)
        underWaveLayer = underWave
        
        boatImageView = UIImageView(image: #imageLiteral(resourceName: "Boat"))
        boatImageView.frame = CGRect(origin: CGPoint(x: bounds.midX - kBoatImageViewSize.width / 2,
                                                     y: bounds.midY - kBoatImageViewSize.height),
                                     size: kBoatImageViewSize)
        addSubview(boatImageView)
        
        waveLayer = CAShapeLayer()
        let path = UIBezierPath(rect: CGRect(x: 0, y: bounds.midY, width: bounds.width, height: bounds.height / 2))
        waveLayer.path = path.cgPath
        underWaveLayer.mask = waveLayer
    }
    
    @objc private func waveLinkRefresh() {
        // Wave width
        let totalWidth: CGFloat = bounds.width
        // Highest wave height - lowest wave height
        let totalHeight: CGFloat = bounds.height - kBoatImageViewSize.height - minWaterDepth
        assert(totalWidth > 0 && totalHeight > 0, "Total width (\(totalWidth)) and total height (\(totalHeight)) must > 0")
        
        func angleInRadians(at x: CGFloat) -> CGFloat {
            return x / totalWidth * (PI_Circle * cycleCount)
        }
        
        func point(at i: Int) -> CGPoint {
            let x = CGFloat(i)
            let angle = angleInRadians(at: x)
            return CGPoint(x: x, y: (1 - sin(angle + currentPhase)) * totalHeight / 2 + kBoatImageViewSize.height)
        }
        
        // Draw wave
        
        UIGraphicsBeginImageContext(CGSize(width: totalWidth, height: totalHeight))
        
        let path = UIBezierPath()
        path.move(to: point(at: 0))
        for i in 1...Int(totalWidth) {
            path.addLine(to: point(at: i))
        }
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: 0, y: bounds.maxY))
        path.close()
        path.fill()
        waveLayer.path = path.cgPath
        underWaveLayer.mask = waveLayer
        
        UIGraphicsEndImageContext()
        
        // Move boat
        
        let centerX = totalWidth / 2
        let bottomCenter = point(at: Int(centerX))
        // Identity translated y
        let transform = CGAffineTransform(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: bottomCenter.y - bounds.midY)
        let angle = angleInRadians(at: centerX)
        let tanValue = -totalHeight / 2 * cos(angle + currentPhase) * angleInRadians(at: 1) // Derivative of y
        boatImageView.transform = transform.rotated(by: atan(tanValue))
        
        currentPhase += step
        if currentPhase > PI_Circle {
            currentPhase -= PI_Circle
        } else if currentPhase < PI_Circle {
            currentPhase += PI_Circle
        }
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
