//
//  WaveVC.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/6/1.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class WaveVC: UIViewController {

    private var boatWaveView: BoatWaveView!
    
    @IBOutlet weak var cycleCountLabel: UILabel!
    @IBOutlet weak var targetWaveHeightLabel: UILabel!
    @IBOutlet weak var horizontalStepLabel: UILabel!
    @IBOutlet weak var minWaterDepthLabel: UILabel!
    @IBOutlet weak var waveHeightStepLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Wave"
        view.backgroundColor = .white
        
        boatWaveView = BoatWaveView(frame: CGRect(x: 0, y: 100, width: view.bounds.width, height: 100))
        view.addSubview(boatWaveView)
    }
    
    @IBAction func cycleCountChanged(_ sender: UISlider) {
        boatWaveView.cycleCount = CGFloat(sender.value)
        cycleCountLabel.text = String(format: "%.2f", sender.value)
    }
    
    @IBAction func targetWaveHeightChanged(_ sender: UISlider) {
        boatWaveView.targetWaveHeight = CGFloat(sender.value)
        targetWaveHeightLabel.text = String(format: "%.2f", sender.value)
    }
    
    @IBAction func horizontalStepChanged(_ sender: UISlider) {
        boatWaveView.horizontalStep = CGFloat(sender.value)
        horizontalStepLabel.text = String(format: "%.2f", sender.value)
    }

    @IBAction func minWaterDepthChanged(_ sender: UISlider) {
        boatWaveView.minWaterDepth = CGFloat(sender.value)
        minWaterDepthLabel.text = String(format: "%.2f", sender.value)
    }
    
    @IBAction func waveHeightStepChanged(_ sender: UISlider) {
        boatWaveView.waveHeightStep = CGFloat(sender.value)
        waveHeightStepLabel.text = String(format: "%.2f", sender.value)
    }
    
    @IBAction func pause(_ sender: UIButton) {
        boatWaveView.pause()
        
    }
    
    @IBAction func stop(_ sender: UIButton) {
        boatWaveView.stop()
    }
    @IBAction func start(_ sender: UIButton) {
        boatWaveView.start()
        
    }
}
