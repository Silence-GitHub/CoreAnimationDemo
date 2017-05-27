//
//  PulsatorVC.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/5/27.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class PulsatorVC: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var maxRadiusLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var intervalLabel: UILabel!
    @IBOutlet weak var maxAlphaLabel: UILabel!
    
    var pulsatorLayer: SWPulsatorLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        pulsatorLayer = SWPulsatorLayer()
        pulsatorLayer.frame = CGRect(x: view.bounds.width / 2, y: 170, width: 0, height: 0)
        view.layer.addSublayer(pulsatorLayer)
        
        countLabel.text = "\(pulsatorLayer.pulseCount)"
        maxRadiusLabel.text = String(format: "%.2f", pulsatorLayer.maxRadius)
        durationLabel.text = String(format: "%.2f", pulsatorLayer.animationDuration)
        intervalLabel.text = String(format: "%.2f", pulsatorLayer.animationInterval)
        maxAlphaLabel.text = String(format: "%.2f", pulsatorLayer.maxAlpha)
    }
    
    @IBAction func countChanged(_ sender: UISlider) {
        pulsatorLayer.pulseCount = Int(sender.value)
        countLabel.text = "\(pulsatorLayer.pulseCount)"
    }
    
    @IBAction func maxRadiusChanged(_ sender: UISlider) {
        pulsatorLayer.maxRadius = CGFloat(sender.value)
        maxRadiusLabel.text = String(format: "%.2f", pulsatorLayer.maxRadius)
    }
    
    @IBAction func durationChanged(_ sender: UISlider) {
        pulsatorLayer.animationDuration = Double(sender.value)
        durationLabel.text = String(format: "%.2f", pulsatorLayer.animationDuration)
    }
    
    @IBAction func intervalChanged(_ sender: UISlider) {
        pulsatorLayer.animationInterval = Double(sender.value)
        intervalLabel.text = String(format: "%.2f", pulsatorLayer.animationInterval)
    }
    
    @IBAction func maxAlphaChanged(_ sender: UISlider) {
        pulsatorLayer.maxAlpha = CGFloat(sender.value)
        maxAlphaLabel.text = String(format: "%.2f", pulsatorLayer.maxAlpha)
    }

    @IBAction func blueToBlue(_ sender: UIButton) {
        pulsatorLayer.inColor = UIColor.blue.cgColor
        pulsatorLayer.outColor = UIColor.blue.cgColor
    }
    
    @IBAction func redToGreen(_ sender: UIButton) {
        pulsatorLayer.inColor = UIColor.red.cgColor
        pulsatorLayer.outColor = UIColor.green.cgColor
    }
    
    @IBAction func orientationChanged(_ sender: UIButton) {
        switch pulsatorLayer.pulseOrientation {
        case .out:
            pulsatorLayer.pulseOrientation = .in
            sender.setTitle("Out", for: .normal)
        default:
            pulsatorLayer.pulseOrientation = .out
            sender.setTitle("In", for: .normal)
        }
    }
    
    @IBAction func startOrStop(_ sender: UIButton) {
        if pulsatorLayer.isAnimating {
            pulsatorLayer.stop()
            sender.setTitle("Start", for: .normal)
        } else {
            pulsatorLayer.start()
            sender.setTitle("Stop", for: .normal)
        }
    }
}
