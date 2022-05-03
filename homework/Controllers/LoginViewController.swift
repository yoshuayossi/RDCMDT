//
//  ViewController.swift
//  homework
//
//  Created by MACPRO-ITAPL on 01/05/22.
//

import UIKit
import iProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var lblErrorUser: UILabel!
    @IBOutlet weak var lblErrorPass: UILabel!
    @IBOutlet weak var lblPlaceUser: UILabel!
    @IBOutlet weak var lblPlacePass: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var leadPlaceUser: NSLayoutConstraint!
    @IBOutlet weak var centerYPlaceUser: NSLayoutConstraint!
    @IBOutlet weak var leadPlacePass: NSLayoutConstraint!
    @IBOutlet weak var centerYPlacePass: NSLayoutConstraint!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.isUserInteractionEnabled = true
        let tapView : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        self.view.addGestureRecognizer(tapView)
        
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        
        self.initElement()
    }

    func initElement() -> Void {
        self.lblPlaceUser.text = "Username"
        self.lblPlaceUser.alpha = 0.5
        self.txtUser.layer.borderWidth = 1
        self.txtUser.layer.borderColor = UIColor.gray.cgColor
        self.txtUser.layer.cornerRadius = 5
        self.lblPlacePass.text = "Password"
        self.lblPlacePass.alpha = 0.5
        self.txtPass.layer.borderWidth = 1
        self.txtPass.layer.borderColor = UIColor.gray.cgColor
        self.txtPass.layer.cornerRadius = 5
        
        self.btnRegister.layer.borderWidth = 1
        self.btnRegister.layer.borderColor = #colorLiteral(red: 0.2117647059, green: 0.4784313725, blue: 0.5176470588, alpha: 1)
        self.btnRegister.layer.cornerRadius = 5
        self.btnLogin.layer.borderWidth = 1
        self.btnLogin.layer.borderColor = UIColor.black.cgColor
        self.btnLogin.layer.cornerRadius = 5
        
        self.lblErrorUser.text = ""
        self.lblErrorPass.text = ""
        
        self.txtUser.delegate = self
        self.txtPass.delegate = self
        
        self.lblBankName.text = Constants.G_BANK_NAME
        
        WebServices.initstate()
    }
    
    @objc func DismissKeyboard()
    {
        self.view.endEditing(true)
    }
    
    @IBAction func doLogin(_ sender: Any) {
        
        self.view.updateCaption(text: "Loading...")
        self.view.updateIndicator(style: .ballClipRotatePulse)
        self.view.showProgress()
        
        let c_user = self.txtUser.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let c_pass = self.txtPass.text?.trimmingCharacters(in: .whitespaces) ?? ""
        self.lblErrorUser.text = ""
        self.lblErrorPass.text = ""
        var isOK = true
        
        if c_user == ""
        {
            self.lblErrorUser.text = "Username is required"
            isOK = false
            self.view.dismissProgress()
        }
        if c_pass == ""
        {
            self.lblErrorPass.text = "Password is required"
            isOK = false
            self.view.dismissProgress()
        }
        if isOK
        {
            WebServices.checkLogin(username: c_user, password: c_pass) { status, jwttoken, msg in
                if status!
                {
                    self.view.dismissProgress()
                    
                    let token = jwttoken ?? ""
                    
                    if token != ""
                    {
                        let username = UserDefaults.standard.string(forKey: "username") ?? ""
                        
                        let nav = UINavigationController()
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let vcHome = story.instantiateViewController(withIdentifier: "dashboard_vc") as! DashboardViewController
                        vcHome.modalPresentationStyle = .fullScreen
                        vcHome.token = token
                        vcHome.username = username
                        
                        nav.viewControllers = [vcHome]
                        
                        UIApplication.shared.windows.first?.rootViewController = nav
                        UIApplication.shared.windows.first?.makeKeyAndVisible()
                    }
                    else
                    {
                        CustomAlert(title: "", msg: "Something goes wrong. Please try again later.", view: self, align: .center)
                    }
                }
                else
                {
                    self.view.dismissProgress()
                    CustomAlert(title: "", msg: msg!, view: self, align: .center)
                }
            }
        }
    }
    
    @IBAction func doRegister(_ sender: Any) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vcRegister = story.instantiateViewController(withIdentifier: "register_vc") as! RegisterViewController
        vcRegister.modalPresentationStyle = .fullScreen
        
        self.present(vcRegister, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          return textField.resignFirstResponder()
      }

      func textFieldDidBeginEditing(_ textField: UITextField) {
          if textField == self.txtUser
          {
              self.centerYPlaceUser.constant = -30
              self.leadPlaceUser.constant = -30
          }
          else if textField == self.txtPass
          {
              self.centerYPlacePass.constant = -30
              self.leadPlacePass.constant = -30
          }
          
          performAnimation(transform: CGAffineTransform(scaleX: 0.8, y: 0.8),textField: textField)
      }

      func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            if textField == self.txtUser
            {
                self.centerYPlaceUser.constant = 0
                self.leadPlaceUser.constant = 5
            }
            else if textField == self.txtPass
            {
                self.centerYPlacePass.constant = 0
                self.leadPlacePass.constant = 5
            }

            performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1),textField: textField)
        }
      }

    fileprivate func performAnimation(transform: CGAffineTransform,textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if textField == self.txtUser
            {
                self.lblPlaceUser.transform = transform
                self.lblPlaceUser.layoutIfNeeded()
            }
            else if textField == self.txtPass{
                self.lblPlacePass.transform = transform
                self.lblPlacePass.layoutIfNeeded()
            }
        }, completion: nil)
    }
}

