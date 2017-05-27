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
    
    var pulseOrientation: Orientation = .out
    
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
    
    var outColor: CGColor = UIColor.blue.cgColor // displayed when radius is max
    var inColor: CGColor = UIColor.red.cgColor // displayed when radius is min
    
    var maxAlpha: CGFloat = 0.5 {
        didSet {
            assert(maxAlpha >= minAlpha && maxAlpha > 0 && maxAlpha <= 1, "Max alpha (\(maxAlpha)) must >= min alpha (\(minAlpha)), > 0 and <= 1")
        }
    }
    
    var minAlpha: CGFloat = 0 {
        didSet {
            assert(minAlpha <= maxAlpha && minAlpha >= 0, "Min alpha (\(minAlpha)) must <= max alpha (\(maxAlpha)) and >= 0")
        }
    }
    
    // Duration for one pulse animation
    var animationDuration: Double = 3 {
        didSet {
            updateInstanceDelay()
        }
    }
    
    // Time interval between repeated pulse animations
    var animationInterval: Double = 1 {
        didSet {
            updateInstanceDelay()
        }
    }
    
    // Number of pulse to display in one pulse animation duration
    var pulseCount: Int = 5 {
        didSet {
            updateInstanceDelay()
        }
    }
    
    override var repeatCount: Float {
        didSet {
            animationGroup?.repeatCount = repeatCount
        }
    }
    
    var pulseLayer: CALayer!
    var animationGroup: CAAnimationGroup!
    
    var isAnimating: Bool {
        return pulseLayer.animation(forKey: kPulseAnimationKey) != nil
    }
    
    override init() {
        super.init()
        
        instanceCount = pulseCount
        updateInstanceDelay()
        repeatCount = MAXFLOAT
        
        pulseLayer = CALayer()
        pulseLayer.opacity = 0
        pulseLayer.backgroundColor = outColor
        pulseLayer.contentsScale = UIScreen.main.scale
        pulseLayer.bounds.size = CGSize(width: maxRadius * 2, height: maxRadius * 2)
        pulseLayer.cornerRadius = maxRadius
        addSublayer(pulseLayer)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateInstanceDelay() {
        instanceDelay = (animationDuration + animationInterval) / Double(pulseCount)
    }
    
    func start() {
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.duration = animationDuration
        
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.duration = animationDuration

        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        
        
        switch pulseOrientation {
        case .out:
            colorAnimation.fromValue = inColor
            colorAnimation.toValue = outColor
            
            scaleAnimation.fromValue = minRadius / maxRadius
            scaleAnimation.toValue = 1
            
            opacityAnimation.fromValue = maxAlpha
            opacityAnimation.toValue = minAlpha
            
        case .in:
            colorAnimation.fromValue = outColor
            colorAnimation.toValue = inColor
            
            scaleAnimation.fromValue = 1
            scaleAnimation.toValue = minRadius / maxRadius
            
            opacityAnimation.fromValue = minAlpha
            opacityAnimation.toValue = maxAlpha
        }
        
        animationGroup = CAAnimationGroup()
        animationGroup.duration = animationDuration + animationInterval
        animationGroup.animations = [colorAnimation, scaleAnimation, opacityAnimation]
        animationGroup.repeatCount = repeatCount
        pulseLayer.add(animationGroup, forKey: kPulseAnimationKey)
    }
    
    func stop() {
        pulseLayer.removeAnimation(forKey: kPulseAnimationKey)
    }
}
