//
//  SWPulsatorLayer.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/5/27.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

private let kPulseAnimationKey: String = "PulseAnimationKey"

class SWPulsatorLayer: CAReplicatorLayer {

    enum Orientation {
        case out
        case `in`
    }
    
    var pulseOrientation: Orientation = .out {
        didSet {
            if pulseOrientation != oldValue {
                restartIfNeeded()
            }
        }
    }
    
    var maxRadius: CGFloat = 50 {
        didSet {
            assert(maxRadius > minRadius, "Max radius (\(maxRadius)) must > min radius (\(minRadius))")
            pulseLayer.bounds.size = CGSize(width: maxRadius * 2, height: maxRadius * 2)
            pulseLayer.cornerRadius = maxRadius
        }
    }
    
    var minRadius: CGFloat = 0 {
        didSet {
            assert(minRadius < maxRadius && minRadius >= 0, "Min radius (\(minRadius)) must < max radius (\(maxRadius)) and >= 0")
        }
    }
    
    var maxAlpha: CGFloat = 0.5 {
        didSet {
            assert(maxAlpha >= minAlpha && maxAlpha > 0 && maxAlpha <= 1, "Max alpha (\(maxAlpha)) must >= min alpha (\(minAlpha)), > 0 and <= 1")
            if maxAlpha != oldValue {
                restartIfNeeded()
            }
        }
    }
    
    var minAlpha: CGFloat = 0 {
        didSet {
            assert(minAlpha <= maxAlpha && minAlpha >= 0, "Min alpha (\(minAlpha)) must <= max alpha (\(maxAlpha)) and >= 0")
            if minAlpha != oldValue {
                restartIfNeeded()
            }
        }
    }
    
    // Pulse color displayed when radius is max
    var outColor: CGColor = UIColor.blue.cgColor {
        didSet {
            if outColor != oldValue {
                restartIfNeeded()
            }
        }
    }
    
    // Pulse color displayed when radius is min
    var inColor: CGColor = UIColor.red.cgColor {
        didSet {
            if inColor != oldValue {
                restartIfNeeded()
            }
        }
    }
    
    // Duration for one pulse animation
    var animationDuration: Double = 3 {
        didSet {
            if animationDuration != oldValue {
                restartIfNeeded()
            }
        }
    }
    
    // Time interval between repeated pulse animations
    var animationInterval: Double = 1 {
        didSet {
            if animationInterval != oldValue {
                restartIfNeeded()
            }
        }
    }
    
    // Number of pulse to display in one pulse animation duration
    var pulseCount: Int = 5 {
        didSet {
            if pulseCount != oldValue {
                instanceCount = pulseCount
                restartIfNeeded()
            }
        }
    }
    
    // Set this property before starting animation
    // Setting after starting animation has no effect
    override var repeatCount: Float {
        didSet {
            animationGroup?.repeatCount = repeatCount
        }
    }
    
    var pulseLayer: CALayer!
    var animationGroup: CAAnimationGroup!
    
    private var isAnimatingBeforeLeaving: Bool = false
    
    var isAnimating: Bool {
        return pulseLayer.animation(forKey: kPulseAnimationKey) != nil
    }
    
    override init() {
        super.init()
        
        instanceCount = pulseCount
        repeatCount = MAXFLOAT
        
        pulseLayer = CALayer()
        pulseLayer.opacity = 0
        pulseLayer.backgroundColor = outColor
        pulseLayer.contentsScale = UIScreen.main.scale
        pulseLayer.bounds.size = CGSize(width: maxRadius * 2, height: maxRadius * 2)
        pulseLayer.cornerRadius = maxRadius
        addSublayer(pulseLayer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resume), name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func save() {
        isAnimatingBeforeLeaving = isAnimating
    }
    
    @objc private func resume() {
        if isAnimatingBeforeLeaving {
            start()
        }
    }
    
    func restartIfNeeded() {
        if isAnimating {
            start()
        }
    }
    
    func start() {
        instanceDelay = (animationDuration + animationInterval) / Double(pulseCount)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.duration = animationDuration
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.duration = animationDuration
        
        switch pulseOrientation {
        case .out:
            scaleAnimation.fromValue = minRadius / maxRadius
            scaleAnimation.toValue = 1
            
            opacityAnimation.fromValue = maxAlpha
            opacityAnimation.toValue = minAlpha
            
            colorAnimation.fromValue = inColor
            colorAnimation.toValue = outColor
            
        case .in:
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = minRadius / maxRadius
            
            opacityAnimation.fromValue = minAlpha
            opacityAnimation.toValue = maxAlpha
            
            colorAnimation.fromValue = outColor
            colorAnimation.toValue = inColor
        }
        
        animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration + animationInterval
        animationGroup.animations = [scaleAnimation, opacityAnimation, colorAnimation]
        animationGroup.repeatCount = repeatCount
        pulseLayer.add(animationGroup, forKey: kPulseAnimationKey)
    }
    
    func stop() {
        pulseLayer.removeAnimation(forKey: kPulseAnimationKey)
    }
}
