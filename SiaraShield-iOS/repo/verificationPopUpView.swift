//
//  verificationPopUpView.swift
//  SiaraShield-iOS
//
//  Created by ShitalJadav on 20/03/23.
//

import UIKit

class verificationPopUpView: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var protectByLabel: UILabel!
    @IBOutlet weak var privacyPolicyLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var protectedByBtn: UIButton!
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
        protectedByBtn.semanticContentAttribute = UIApplication.shared
            .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        let origImage = UIImage(named: "logo")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        protectedByBtn.setImage(tintedImage, for: .normal)
        protectedByBtn.tintColor = .lightGray
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
        protectedByBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
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
        // create the closure
        let optionClosure = {(action: UIAction) in
            print(action.title)
            self.moreBtn.setTitle("", for: .normal)
            if action.title == "Accessibility" {
                guard let url = URL(string: "https://www.cybersiara.com/accessibility") else {
                     return
                }
                if UIApplication.shared.canOpenURL(url) {
                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if action.title == "Report Image" {
                guard let url = URL(string: "https://www.cybersiara.com") else {
                     return
                }
                if UIApplication.shared.canOpenURL(url) {
                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if action.title == "Report Bug" {
                guard let url = URL(string: "https://www.cybersiara.com") else {
                     return
                }
                if UIApplication.shared.canOpenURL(url) {
                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        // create an array to store the actions
        var optionsArray = [UIAction]()
        let arritems = ["Accessibility", "Report Image", "Report Bug"]
        // loop and populate the actions array
        for item in arritems {
            // create each action and insert the right item as a title
            let action = UIAction(title: item, state: .off, handler: optionClosure)
            // add newly created action to actions array
            optionsArray.append(action)
        }
        // set the state of first country in the array as ON
       // optionsArray[0].state = .on
        // create an options menu
        let optionsMenu = UIMenu(title: "", options: .displayInline, children: optionsArray)
        // add everything to your button
        moreBtn.menu = optionsMenu
        // make sure the popup button shows the selected value
        moreBtn.changesSelectionAsPrimaryAction = true
        moreBtn.showsMenuAsPrimaryAction = true
        self.moreBtn.setTitle("", for: .normal)
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.onTapPrivacyPolicy))
        privacyPolicyLabel.isUserInteractionEnabled = true
        privacyPolicyLabel.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.onTapProtectedBy))
        protectByLabel.addGestureRecognizer(tap2)
        protectByLabel.isUserInteractionEnabled = true
    }
    
    // MARK: Functions
    @objc func onTapPrivacyPolicy(sender:UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.cybersiara.com/privacy") else {
             return
        }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc func onTapProtectedBy(sender:UITapGestureRecognizer) {
        guard let url = URL(string: "https://www.cybersiara.com") else {
             return
        }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
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
