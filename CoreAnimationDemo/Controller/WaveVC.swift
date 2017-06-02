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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        boatWaveView = BoatWaveView(frame: CGRect(x: 10, y: 200, width: view.bounds.width - 20, height: 100))
        view.addSubview(boatWaveView)
    }

    @IBAction func startOrStop(_ sender: UIButton) {
        if boatWaveView.isAnimating {
            boatWaveView.stop()
            sender.setTitle("Start", for: .normal)
        } else {
            boatWaveView.start()
            sender.setTitle("Stop", for: .normal)
        }
    }
}
