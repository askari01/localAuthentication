//
//  VerifyPassCode.swift
//  LocalAuth
//
//  Created by Syed Askari on 8/17/18.
//  Copyright © 2018 Syed Askari. All rights reserved.
//

import UIKit
import LocalAuthentication
import AudioToolbox

private var __maxLengths = [UITextField: Int]()

class VerifyPassCode: UIViewController {
    
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
            authUser()
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
                        self.performSegue(withIdentifier: "codeVerifyed", sender: self)
                        self.check(count: 4)
                    } else {
                        let ac = UIAlertController(title: "Authentication failed or Cancelled", message: "Use Passcode", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(ac, animated: true)
                        print ("PASS TO ID, Auth Failed")
                        self.check(count: 0)
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Touch ID or Face ID is not available", message: "Your device is not configured for Touch ID or Face ID.", preferredStyle: .alert)
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
            if textfield.text! == UserDefaults.standard.value(forKey: "code") as! String {
                self.performSegue(withIdentifier: "codeVerifyed", sender: self)
            } else {
                self.blockView.shake()
                self.textfield.text = ""
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.09) {
                    self.check(count: 0)
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "codeVerifyed" {

        }
    }
}
