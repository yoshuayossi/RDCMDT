//
//  RegisterViewController.swift
//  homework
//
//  Created by MACPRO-ITAPL on 02/05/22.
//

import UIKit
import iProgressHUD
import FontAwesome_swift

class RegisterViewController: UIViewController {

    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var lblPlaceUser: UILabel!
    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var lblPlacePass: UILabel!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var lblPlaceConfirmPass: UILabel!
    @IBOutlet weak var lblErrorUser: UILabel!
    @IBOutlet weak var lblErrorPass: UILabel!
    @IBOutlet weak var lblErrorConfirmPass: UILabel!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var leadPlaceUser: NSLayoutConstraint!
    @IBOutlet weak var centerYPlaceUser: NSLayoutConstraint!
    @IBOutlet weak var leadPlacePass: NSLayoutConstraint!
    @IBOutlet weak var centerYPlacePass: NSLayoutConstraint!
    @IBOutlet weak var leadPlaceConfirmPass: NSLayoutConstraint!
    @IBOutlet weak var centerYPlaceConfirmPass: NSLayoutConstraint!
    @IBOutlet weak var btnBack: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        
        self.view.isUserInteractionEnabled = true
        let tapView : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        self.view.addGestureRecognizer(tapView)
        
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
        self.lblPlaceConfirmPass.text = "Confirm Password"
        self.lblPlaceConfirmPass.alpha = 0.5
        self.txtConfirmPass.layer.borderWidth = 1
        self.txtConfirmPass.layer.borderColor = UIColor.gray.cgColor
        self.txtConfirmPass.layer.cornerRadius = 5
        
        self.btnRegister.layer.cornerRadius = 5
        self.btnBack.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        self.btnBack.setTitle(String.fontAwesomeIcon(name: .arrowLeft), for: .normal)
        
        self.lblErrorUser.text = ""
        self.lblErrorPass.text = ""
        self.lblErrorConfirmPass.text = ""
        
        self.txtUser.delegate = self
        self.txtPass.delegate = self
        self.txtConfirmPass.delegate = self
        
        self.lblBankName.text = Constants.G_BANK_NAME
    }
    
    @objc func DismissKeyboard()
    {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func doBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doRegister(_ sender: Any) {
        
        self.view.updateCaption(text: "Loading...")
        self.view.updateIndicator(style: .ballClipRotatePulse)
        self.view.showProgress()
        
        let c_user = self.txtUser.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let c_pass = self.txtPass.text?.trimmingCharacters(in: .whitespaces) ?? ""
        let c_cpas = self.txtConfirmPass.text?.trimmingCharacters(in: .whitespaces) ?? ""
        self.lblErrorUser.text = ""
        self.lblErrorPass.text = ""
        self.lblErrorConfirmPass.text = ""
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
        if c_cpas == ""
        {
            self.lblErrorConfirmPass.text = "Confirm Password is required"
            isOK = false
            self.view.dismissProgress()
        }
        if c_pass != c_cpas
        {
            self.lblErrorConfirmPass.text = "Confirm Password not match"
            isOK = false
            self.view.dismissProgress()
        }
        
        if isOK
        {
            let user = User(username: c_user, accountno: "", balance: 0, password: c_pass)
            WebServices.doRegister(user: user) { status, msg in
                if status!
                {
                    WebServices.checkLogin(username: c_user, password: c_pass) { status2, jwttoken, msg2 in
                        if status2!
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
                            CustomAlert(title: "", msg: msg2!, view: self, align: .center)
                        }
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
    
}

extension RegisterViewController: UITextFieldDelegate {
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
        else if textField == self.txtConfirmPass
        {
            self.centerYPlaceConfirmPass.constant = -30
            self.leadPlaceConfirmPass.constant = -30
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
          if textField == self.txtConfirmPass
          {
              self.centerYPlaceConfirmPass.constant = 0
              self.leadPlaceConfirmPass.constant = 5
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
          if textField == self.txtConfirmPass{
              self.lblPlaceConfirmPass.transform = transform
              self.lblPlaceConfirmPass.layoutIfNeeded()
          }
      }, completion: nil)
  }
}
