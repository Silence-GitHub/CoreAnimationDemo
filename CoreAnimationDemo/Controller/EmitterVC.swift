//
//  EmitterVC.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/6/1.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class EmitterVC: UIViewController {

    private var rainLayer: CAEmitterLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupRainLayer()
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
    }
    
    @IBAction func leftHeartButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func rightHeartButtonClicked(_ sender: UIButton) {
    }
}
