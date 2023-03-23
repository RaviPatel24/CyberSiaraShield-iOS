//
//  verificationPopUpView.swift
//  SiaraShield-iOS
//
//  Created by ShitalJadav on 20/03/23.
//

import UIKit
class verificationPopUpView: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var protectedByLabel: UIButton!
    @IBOutlet weak var txtSecretcode: UITextField!
    @IBOutlet weak var lettrsview: UIImageView!
    @IBOutlet weak var txtLanguage: DropDown!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var eyeIconButton: UIButton!
    
    // MARK: Variables
    var objGenerateCaptcha = GenerateCaptchaViewModel()
    var objCaptchaVerify = CaptchaVerifyViewModel()
    var isCaptchaShowing : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProgressHUD.show()
        protectedByLabel.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        let origImage = UIImage(named: "logo")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        protectedByLabel.setImage(tintedImage, for: .normal)
        protectedByLabel.tintColor = .lightGray
        objGenerateCaptcha.generateCaptchaAPICall()  { isSuccess in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                if isSuccess{
                    if captcha != "" {
                        if let imageURL = UIImage.gif(url: captcha) {
                            self.lettrsview.image = imageURL
                        } else {
                            self.presentAlert(withTitle: "Captcha", message: "Wrong Captcha Url found!")
                        }
                        
                    } else {
                        self.presentAlert(withTitle: "Captcha", message: "Captcha not found!")
                    }
                } else {
                    self.presentAlert(withTitle: "Error", message: "Captcha not found!!")
                }
            }
        }
        protectedByLabel.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        mainView.layer.cornerRadius = 10
        mainView.layer.shadowColor = UIColor.lightGray.cgColor
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 5
        txtLanguage.layer.cornerRadius = 10
        txtSecretcode.layer.shadowColor = UIColor.lightGray.cgColor
        txtSecretcode.layer.shadowOpacity = 1
        txtSecretcode.layer.shadowOffset = CGSize.zero
        txtSecretcode.layer.shadowRadius = 5
        lettrsview.layer.borderWidth = 1
        lettrsview.layer.borderColor = UIColor.lightGray.cgColor
        txtSecretcode.delegate = self
        txtSecretcode.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: txtSecretcode.frame.height))
        txtSecretcode.leftViewMode = .always
    }
    
    // MARK: Actions
    @IBAction func onTapRefresh(_ sender: UIButton) {
        ProgressHUD.show()
        objGenerateCaptcha.generateCaptchaAPICall()  { isSuccess in
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                if isSuccess{
                    if captcha != "" {
                        if let imageURL = UIImage.gif(url: captcha) {
                            self.lettrsview.image = imageURL
                        } else {
                            self.presentAlert(withTitle: "Captcha", message: "Wrong Captcha Url found!")
                        }
                    } else {
                        self.presentAlert(withTitle: "Error", message: "Captcha not found!")
                    }
                } else {
                    self.presentAlert(withTitle: "Error", message: "Captcha not found!!")
                }
            }
        }
        
    }
    @IBAction func onTapClose(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: Notification.Name("VerifyPopUp"), object: false)
        })
    }
    
    @IBAction func OnTapHideShowcaptchaCode(_ sender: UIButton) {
        if self.isCaptchaShowing == false { // Not Showing
            self.isCaptchaShowing = true
            self.txtSecretcode.isSecureTextEntry = false //Show
            if let image = UIImage(named: "password-visibility-icon") {
                self.eyeIconButton.setImage(image, for: .normal)
            }
        }
        else if self.isCaptchaShowing == true { // Showing
            self.isCaptchaShowing = false
            self.txtSecretcode.isSecureTextEntry = true //hide
            if let image = UIImage(named: "password-hide-icon") {
                self.eyeIconButton.setImage(image, for: .normal)
            }
        }
    }
    
}

extension verificationPopUpView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return pressed")
        textField.resignFirstResponder()
        if captcha != "" {
            ProgressHUD.show()
            objCaptchaVerify.captchaVerifyAPICall(userCaptcha: self.txtSecretcode.text ?? "") { isSuccess in
                DispatchQueue.main.async {
                    ProgressHUD.dismiss()
                    if isSuccess{
                        self.dismiss(animated: true, completion: {
                            NotificationCenter.default.post(name: Notification.Name("VerifyPopUp"), object: true)
                        })
                    } else {
                        self.presentAlert(withTitle: "Error", message: "Wrong Captcha, Please enter again!")
                    }
                }
            }
            
        } else {
            self.presentAlert(withTitle: "Error", message: "Captcha not found!!")
        }
        return false
    }
    
    @objc func textFieldDidChange(_ textField : UITextField) {
        
        if textField == self.txtSecretcode {
            if self.txtSecretcode.text!.count > 0 {
                self.eyeIconButton.isHidden = false
            }
            else if self.txtSecretcode.text!.count < 1 {
                self.eyeIconButton.isHidden = true
            }
        }
    }
}
