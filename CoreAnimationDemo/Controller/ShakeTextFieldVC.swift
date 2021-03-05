//
//  ShakeTextFieldVC.swift
//  CoreAnimationDemo
//
//  Created by Alvin Tu on 3/5/21.
//  Copyright © 2021 Kaibo Lu. All rights reserved.
//

import UIKit

class ShakeTextFieldVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var shakingTextField: ShakingTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        shakingTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        shakingTextField.shakeVertical()

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        shakingTextField.shakeCrazy()

    }

    
    
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count > 8 {
            shakingTextField.shakeHorizontal()
            textField.text = ""
            return false
        }
        return true
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        shakingTextField.resignFirstResponder()
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
