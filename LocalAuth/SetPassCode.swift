//
//  ViewController.swift
//  LocalAuth
//
//  Created by Syed Askari on 8/16/18.
//  Copyright © 2018 Syed Askari. All rights reserved.
//

import UIKit
import LocalAuthentication
import AudioToolbox

private var __maxLengths = [UITextField: Int]()

class SetPassCode: UIViewController {

    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var one: UIView!
    @IBOutlet weak var two: UIView!
    @IBOutlet weak var three: UIView!
    @IBOutlet weak var four: UIView!
    @IBOutlet weak var blockView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textfield.becomeFirstResponder()
        textfield.addTarget(self, action: #selector(SetPassCode.textFieldDidChange(textField:)), for: .editingChanged)
        viewSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey: "code") != nil {
            print (UserDefaults.standard.integer(forKey: "code"))
            self.performSegue(withIdentifier: "verifyCode", sender: self)
//            authUser()
        } else {
            textfield.becomeFirstResponder()
            textfield.text = ""
            check(count: 0)
        }
    }
    
    @IBAction func unlock(_ sender: UIButton) {
        authUser()
    }
    
    
    func viewSetup() {
        textfield.alpha = 0.0
        
        one.layer.backgroundColor = UIColor.clear.cgColor
        two.layer.backgroundColor = UIColor.clear.cgColor
        three.layer.backgroundColor = UIColor.clear.cgColor
        four.layer.backgroundColor = UIColor.clear.cgColor
        
        one.layer.borderWidth = 1.5
        one.layer.borderColor = UIColor.lightGray.cgColor
        one.clipsToBounds = true
        one.layer.cornerRadius = one.frame.width / 2.0
        
        two.layer.borderWidth = 1.5
        two.layer.borderColor = UIColor.lightGray.cgColor
        two.clipsToBounds = true
        two.layer.cornerRadius = two.frame.width / 2.0
        
        three.layer.borderWidth = 1.5
        three.layer.borderColor = UIColor.lightGray.cgColor
        three.clipsToBounds = true
        three.layer.cornerRadius = three.frame.width / 2.0
        
        four.layer.borderWidth = 1.5
        four.layer.borderColor = UIColor.lightGray.cgColor
        four.clipsToBounds = true
        four.layer.cornerRadius = four.frame.width / 2.0
    }
    
    func authUser() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify User!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [unowned self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        print ("Success")
//                        self.performSegue(withIdentifier: "", sender: self)
//                        self.check(count: 4)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "Sorry!", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                        print ("PASS TO ID, Auth Failed")
//                        self.check(count: 4)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID not available", message: "Your device is not configured for Touch ID.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            print ("PASS TO ID, Auth not available")
        }
    }
    
    @objc
    func textFieldDidChange(textField : UITextField) {
        //        label.text = yourTextField.text?.characters.count
        print ("Calue0: \(textfield.text) - COUNT: \(textfield.text?.count) ")
        check(count: (textfield.text?.count)!)
    }
    
    func check(count: Int) {
        print ("Calue1: \(textfield.text) - COUNT: \(textfield.text?.count) ")
        print(count)
        switch count {
        case 0:
            one.layer.backgroundColor = UIColor.clear.cgColor
            two.layer.backgroundColor = UIColor.clear.cgColor
            three.layer.backgroundColor = UIColor.clear.cgColor
            four.layer.backgroundColor = UIColor.clear.cgColor
        case 1:
            one.layer.backgroundColor = UIColor.red.cgColor
            two.layer.backgroundColor = UIColor.clear.cgColor
            three.layer.backgroundColor = UIColor.clear.cgColor
            four.layer.backgroundColor = UIColor.clear.cgColor
        case 2:
            one.layer.backgroundColor = UIColor.red.cgColor
            two.layer.backgroundColor = UIColor.green.cgColor
            three.layer.backgroundColor = UIColor.clear.cgColor
            four.layer.backgroundColor = UIColor.clear.cgColor
        case 3:
            one.layer.backgroundColor = UIColor.red.cgColor
            two.layer.backgroundColor = UIColor.green.cgColor
            three.layer.backgroundColor = UIColor.blue.cgColor
            four.layer.backgroundColor = UIColor.clear.cgColor
        case 4:
            one.layer.backgroundColor = UIColor.red.cgColor
            two.layer.backgroundColor = UIColor.green.cgColor
            three.layer.backgroundColor = UIColor.blue.cgColor
            four.layer.backgroundColor = UIColor.yellow.cgColor
        default:
            print ("greater values")
        }
        if count == 4 {
//            if textfield.text! == "0000" {
                self.performSegue(withIdentifier: "verifyPassCode", sender: self)
//            } else {
//                self.blockView.shake()
//                self.textfield.text = ""
//                let generator = UINotificationFeedbackGenerator()
//                generator.notificationOccurred(.error)
//                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.09) {
//                    self.check(count: 0)
//                }
//            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verifyPassCode" {
            guard let vc = segue.destination as? ConfirmPassCode else {
                return
            }
            vc.code = self.textfield.text!
        }
    }
}

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension String
{
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String(Array(self).prefix(upTo: n))
    }
}

extension UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-7.0, 7.0, -7.0, 7.0, -5.0, 5.0, -2.0, 2.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}

