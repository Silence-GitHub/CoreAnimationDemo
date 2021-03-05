//
//  PulsatingTapVC.swift
//  CoreAnimationDemo
//
//  Created by Alvin Tu on 3/5/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import UIKit

class PulsatingTapVC: UIViewController {

    @IBOutlet weak var plainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plainView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PulsatingTapVC.addPulse))
        tapGestureRecognizer.numberOfTapsRequired = 1
        plainView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
    }
    
    @objc func addPulse() {
        let pulse = Pulsing(numberOfPulses: 1, radius: 110, position: plainView.center)
        pulse.animationDuration = 0.8
        pulse.backgroundColor = UIColor.blue.cgColor
        print("pulse")
        self.view.layer.insertSublayer(pulse, below: plainView.layer)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
