//
//  WaveVC.swift
//  CoreAnimationDemo
//
//  Created by Kaibo Lu on 2017/6/1.
//  Copyright © 2017年 Kaibo Lu. All rights reserved.
//

import UIKit

class WaveVC: UIViewController {

    private var waveLayer: CAShapeLayer!
    private var currentPhase: CGFloat = 0
    private var waveLink: CADisplayLink!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        waveLayer = CAShapeLayer()
        waveLayer.frame = CGRect(x: 10, y: 200, width: view.bounds.width - 20, height: 100)
        waveLayer.fillColor = UIColor.white.cgColor
        waveLayer.strokeColor = UIColor.blue.cgColor
        view.layer.addSublayer(waveLayer)
        
        waveLink = CADisplayLink(target: self, selector: #selector(waveLinkRefresh))
        waveLink.isPaused = true
        waveLink.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    @objc private func waveLinkRefresh() {
        let totalWidth: CGFloat = waveLayer.frame.width
        let totalHeight: CGFloat = waveLayer.frame.height
        let cycleCount: CGFloat = 3
        UIGraphicsBeginImageContext(CGSize(width: totalWidth, height: totalHeight))
        
        func point(at i: Int) -> CGPoint {
            let x = CGFloat(i)
            let angle = x / totalWidth * (CGFloat.pi * 2 * cycleCount)
            return CGPoint(x: x, y: sin(angle + currentPhase) * totalHeight / 2)
        }
        
        let path = UIBezierPath()
        path.move(to: point(at: 0))
        for i in 1...Int(totalWidth) {
            path.addLine(to: point(at: i))
        }
        path.stroke()
        
        currentPhase += 0.1
        waveLayer.path = path.cgPath
        
        UIGraphicsEndImageContext()
    }

    @IBAction func startOrStop(_ sender: UIButton) {
        waveLink.isPaused = !waveLink.isPaused
        sender.setTitle(waveLink.isPaused ? "Start" : "Stop", for: .normal)
    }
}
