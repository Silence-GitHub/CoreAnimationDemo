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
     Wave horizontal move step.
     A positive value specifies right movement, a negative value specifies left movement.
     This value should NOT be 0.
     */
    var horizontalStep: CGFloat = 0.05 {
        didSet {
            assert(horizontalStep != 0, "Horizontal step (\(horizontalStep)) must != 0")
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
    
    /*
      _ <- H
     / \
        \_/ <- L
     
     The height between a wave highest point and lowest point (H - L).
     This value should be greater than or equal to 0.
     */
    var waveHeight: CGFloat = 0 {
        didSet {
            assert(waveHeight >= 0 && waveHeight <= maxWaveHeight, "Wave height (\(waveHeight)) must >= 0 and <= \(maxWaveHeight)")
        }
    }
    
    var maxWaveHeight: CGFloat {
        return bounds.height - kBoatImageViewSize.height - minWaterDepth
    }
    
    /**
     Target wave height to change.
     Change this value will make wave height change by step (see waveHeightStep property) until wave height is equal to this value.
     */
    var targetWaveHeight: CGFloat = 50 {
        didSet {
            assert(targetWaveHeight >= 0 && targetWaveHeight <= maxWaveHeight,
                   "Target wave height (\(targetWaveHeight)) must >= 0 and <= \(maxWaveHeight)")
            if targetWaveHeight > 0 {
                lastPositiveTargetWaveHeight = targetWaveHeight
            }
        }
    }
    
    /**
     Use this value to start animation if target wave height is 0.
     */
    private var lastPositiveTargetWaveHeight: CGFloat = 50
    
    /**
     Step of wave height change each time
     */
    var waveHeightStep: CGFloat = 0.2 {
        didSet {
            assert(waveHeightStep > 0, "Wave height step (\(waveHeightStep)) must > 0")
        }
    }
    
    /**
     A wave lowest point height. See waveHeight property.
     This value should be greater than 0.
     */
    var minWaterDepth: CGFloat = 20 {
        didSet {
            assert(minWaterDepth > 0, "Min water depth (\(minWaterDepth)) must > 0")
            updateBoatFrame()
            updateWaveWhenNoAnimation()
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
        NotificationCenter.default.addObserver(self, selector: #selector(stop), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(start), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        let sky = CAGradientLayer()
        sky.frame = bounds
        sky.colors = [UIColor(red: 0.663, green: 0.812, blue: 0.961, alpha: 1).cgColor,
                      UIColor.white.cgColor]
        layer.addSublayer(sky)
        skyLayer = sky
        
        boatImageView = UIImageView(image: #imageLiteral(resourceName: "Boat"))
        updateBoatFrame()
        addSubview(boatImageView)
        
        let underWave = CAGradientLayer()
        underWave.frame = bounds
        underWave.colors = [UIColor(red: 0.471, green: 0.784, blue: 1.000, alpha: 1).cgColor,
                            UIColor(red: 0.122, green: 0.365, blue: 0.788, alpha: 1).cgColor]
        layer.addSublayer(underWave)
        underWaveLayer = underWave
        
        waveLayer = CAShapeLayer()
        updateWaveWhenNoAnimation()
    }
    
    private func updateWaveWhenNoAnimation() {
        guard !isAnimating else { return }
        let path = UIBezierPath(rect: CGRect(x: 0,
                                             y: bounds.maxY - minWaterDepth - waveHeight / 2,
                                             width: bounds.width,
                                             height: minWaterDepth + waveHeight / 2))
        waveLayer.path = path.cgPath
        underWaveLayer.mask = waveLayer
    }
    
    private func updateBoatFrame() {
        let transform = boatImageView.transform
        boatImageView.transform = .identity
        boatImageView.frame = CGRect(origin: CGPoint(x: bounds.midX - kBoatImageViewSize.width / 2,
                                                     y: bounds.maxY - minWaterDepth - waveHeight / 2 - kBoatImageViewSize.height),
                                     size: kBoatImageViewSize)
        boatImageView.transform = transform
    }
    
    @objc private func waveLinkRefresh() {
        defer {
            var needToUpdate = false
            if waveHeight < targetWaveHeight {
                let temp = waveHeight + waveHeightStep
                if temp > targetWaveHeight {
                    waveHeight = targetWaveHeight
                } else {
                    waveHeight = temp
                }
                needToUpdate = true
            } else if waveHeight > targetWaveHeight {
                let temp = waveHeight - waveHeightStep
                if temp < targetWaveHeight {
                    waveHeight = targetWaveHeight
                } else {
                    waveHeight = temp
                }
                needToUpdate = true
            }
            if needToUpdate {
                updateBoatFrame()
            }
        }
        guard waveHeight > 0 else {
            if targetWaveHeight == 0 {
                waveLink?.isPaused = true
            }
            return
        }
        let totalWidth: CGFloat = bounds.width
        assert(totalWidth > 0 && waveHeight <= maxWaveHeight,
               "Total width (\(totalWidth)) must > 0 and wave height (\(waveHeight)) must <= \(maxWaveHeight)")
        
        func angleInRadians(at x: CGFloat) -> CGFloat {
            return x / totalWidth * (PI_Circle * cycleCount)
        }
        
        func point(at i: Int) -> CGPoint {
            let x = CGFloat(i)
            let angle = angleInRadians(at: x)
            return CGPoint(x: x, y: bounds.height - minWaterDepth - (sin(angle + currentPhase) + 1) * waveHeight / 2)
        }
        
        // Draw wave
        
        UIGraphicsBeginImageContext(CGSize(width: totalWidth, height: waveHeight))
        
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
        let transform = CGAffineTransform(a: 1, b: 0,
                                          c: 0, d: 1,
                                          tx: 0, ty: bottomCenter.y - (bounds.maxY - minWaterDepth - waveHeight / 2))
        let angle = angleInRadians(at: centerX)
        let tanValue = -waveHeight / 2 * cos(angle + currentPhase) * angleInRadians(at: 1) // Derivative of y
        boatImageView.transform = transform.rotated(by: atan(tanValue))
        
        currentPhase += horizontalStep
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
            waveLink?.add(to: .current, forMode: RunLoop.Mode.default)
//            waveLink?.add(to: .current, forMode: .defaultRunLoopMode)
        }
    }
    
    /**
     Start animation. If wave height is 0, use last positive wave height.
     */
    @objc func start() {
        if waveHeight == 0, targetWaveHeight == 0 {
            targetWaveHeight = lastPositiveTargetWaveHeight
        }
        waveLink?.isPaused = false
    }
    
    /**
     Pause animation.
     */
    func pause() {
        waveLink?.isPaused = true
    }
    
    /**
     Stop animation by reducing wave height step by step until it is 0.
     */
    @objc func stop() {
        targetWaveHeight = 0
    }

}
