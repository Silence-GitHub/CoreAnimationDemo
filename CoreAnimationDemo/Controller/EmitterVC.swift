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
    @IBOutlet weak var leftHeartButton: UIButton!
    @IBOutlet weak var rightHeartButton: UIButton!
    
    private var rainLayer: CAEmitterLayer!
    
    private var centerHeartLayer: CAEmitterLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRainLayer()
        setupCenterHeartLayer()
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
        cell.contents = #imageLiteral(resourceName: "Heart").cgImage
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
        cell.contents = #imageLiteral(resourceName: "Heart").cgImage
        cell.lifetime = 1
        cell.birthRate = 2000
        cell.scale = 0.05
        cell.scaleSpeed = -0.02
        cell.velocity = 30
        cell.alphaSpeed = -1
        centerHeartLayer.emitterCells = [cell]
        
        view.layer.addSublayer(centerHeartLayer)
    }

    @IBAction func rainButtonClicked(_ sender: UIButton) {
        let birthRateAnimation = CABasicAnimation(keyPath: "birthRate")
        birthRateAnimation.duration = 5
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
        centerHeartLayer.beginTime = CACurrentMediaTime() // There will be too many cell without setting begin time
        centerHeartLayer.birthRate = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.centerHeartLayer.birthRate = 0
        }
    }
    
    @IBAction func leftHeartButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func rightHeartButtonClicked(_ sender: UIButton) {
    }
}
