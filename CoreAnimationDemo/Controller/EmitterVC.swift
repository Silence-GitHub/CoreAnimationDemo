//
//  EmitterVC.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/6/1.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class EmitterVC: UIViewController {

    @IBOutlet weak var centerHeartButton: UIButton!
    
    private var rainLayer: CAEmitterLayer!
    
    private var centerHeartLayer: CAEmitterLayer!
    private var leftHeartLayer: CAEmitterLayer!
    private var rightHeartLayer: CAEmitterLayer!
    
    private var gravityLayer: CAEmitterLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRainLayer()
        setupCenterHeartLayer()
        setupLeftHeartLayer()
        setupRightHeartLayer()
        setupGravityLayer()
    }
    
    private func setupRainLayer() {
        rainLayer = CAEmitterLayer()
        rainLayer.emitterShape = kCAEmitterLayerLine // Default emit orientation is up
        rainLayer.emitterMode = kCAEmitterLayerOutline
        rainLayer.renderMode = kCAEmitterLayerOldestFirst
        rainLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: 0)
        rainLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
        rainLayer.birthRate = 0 // Stop animation by default
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.scale = 0.1
        cell.lifetime = 5
        cell.birthRate = 1000
        cell.velocity = 500
        cell.emissionLongitude = CGFloat.pi
        
        rainLayer.emitterCells = [cell]
        view.layer.addSublayer(rainLayer)
    }
    
    private func setupCenterHeartLayer() {
        centerHeartLayer = CAEmitterLayer()
        centerHeartLayer.emitterShape = kCAEmitterLayerCircle
        centerHeartLayer.emitterMode = kCAEmitterLayerOutline
        centerHeartLayer.renderMode = kCAEmitterLayerOldestFirst
        centerHeartLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        centerHeartLayer.emitterSize = centerHeartButton.frame.size
        centerHeartLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.lifetime = 1
        cell.birthRate = 2000
        cell.scale = 0.05
        cell.scaleSpeed = -0.02
        cell.alphaSpeed = -1
        cell.velocity = 30
        
        centerHeartLayer.emitterCells = [cell]
        view.layer.addSublayer(centerHeartLayer)
    }
    
    private func setupLeftHeartLayer() {
        leftHeartLayer = CAEmitterLayer()
        leftHeartLayer.emitterShape = kCAEmitterLayerPoint // default value, emit orientation is right
        leftHeartLayer.emitterMode = kCAEmitterLayerVolume // default value
        leftHeartLayer.renderMode = kCAEmitterLayerOldestFirst
        leftHeartLayer.emitterPosition = CGPoint(x: view.bounds.midX * 0.5, y: view.bounds.midY)
        leftHeartLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.scale = 0.5
        cell.lifetime = 1
        cell.birthRate = 10 // emit duration = 0.1, only 1 cell displayed each time
        cell.alphaSpeed = -1
        cell.velocity = 50
        cell.emissionLongitude = -CGFloat.pi / 2
        
        leftHeartLayer.emitterCells = [cell]
        view.layer.addSublayer(leftHeartLayer)
    }
    
    private func setupRightHeartLayer() {
        rightHeartLayer = CAEmitterLayer()
        rightHeartLayer.renderMode = kCAEmitterLayerOldestFirst
        rightHeartLayer.emitterPosition = CGPoint(x: view.bounds.midX * 1.5, y: view.bounds.midY)
        rightHeartLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.scale = 0.5
        cell.lifetime = 1
        cell.birthRate = 5
        cell.alphaSpeed = -1
        cell.velocity = 50
        cell.emissionLongitude = -CGFloat.pi / 2
        cell.emissionRange = CGFloat.pi / 4
        
        rightHeartLayer.emitterCells = [cell]
        view.layer.addSublayer(rightHeartLayer)
    }
    
    private func setupGravityLayer() {
        gravityLayer = CAEmitterLayer()
        gravityLayer.renderMode = kCAEmitterLayerOldestFirst
        gravityLayer.emitterPosition = CGPoint(x: 0, y: view.bounds.maxY)
        gravityLayer.birthRate = 0
        
        let cell = CAEmitterCell()
        cell.contents = #imageLiteral(resourceName: "Heart_red").cgImage
        cell.scale = 0.5
        cell.lifetime = 10
        cell.alphaSpeed = -0.1
        cell.birthRate = 10
        cell.velocity = 100
        cell.yAcceleration = 20
        cell.emissionLongitude = -CGFloat.pi / 4
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 0 // default value
        cell.spinRange = CGFloat.pi * 2
        
        let cell2 = CAEmitterCell()
        cell2.contents = #imageLiteral(resourceName: "Heart_blue").cgImage
        cell2.scale = 0.3
        cell2.lifetime = 20
        cell2.alphaSpeed = -0.05
        cell2.birthRate = 5
        cell2.velocity = 135
        cell2.yAcceleration = 20
        cell2.emissionLongitude = -CGFloat.pi / 4
        cell2.emissionRange = CGFloat.pi / 4
        cell2.spin = 0 // default value
        cell2.spinRange = CGFloat.pi * 2
        
        gravityLayer.emitterCells = [cell, cell2]
        view.layer.addSublayer(gravityLayer)
    }

    @IBAction func rainButtonClicked(_ sender: UIButton) {
        let birthRateAnimation = CABasicAnimation(keyPath: "birthRate")
        birthRateAnimation.duration = 3
        if rainLayer.birthRate == 0 {
            birthRateAnimation.fromValue = 0
            birthRateAnimation.toValue = 1
            rainLayer.birthRate = 1
        } else {
            birthRateAnimation.fromValue = 1
            birthRateAnimation.toValue = 0
            rainLayer.birthRate = 0
        }
        rainLayer.add(birthRateAnimation, forKey: "birthRate")
    }
    
    @IBAction func centerHeartButtonClicked(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        centerHeartLayer.beginTime = CACurrentMediaTime() // There will be too many cell without setting begin time
        centerHeartLayer.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.centerHeartLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func leftHeartButtonClicked(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        leftHeartLayer.beginTime = CACurrentMediaTime() - 0.05
        leftHeartLayer.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.leftHeartLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func rightHeartButtonClicked(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        rightHeartLayer.beginTime = CACurrentMediaTime() - 0.5
        rightHeartLayer.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.rightHeartLayer.birthRate = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) { [weak self] in
            guard self != nil else { return }
            sender.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func gravityButtonClicked(_ sender: UIButton) {
        if gravityLayer.birthRate == 0 {
            gravityLayer.beginTime = CACurrentMediaTime()
            gravityLayer.birthRate = 1
        } else {
            gravityLayer.birthRate = 0
        }
    }
}
