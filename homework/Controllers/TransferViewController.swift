//
//  TransferViewController.swift
//  homework
//
//  Created by MACPRO-ITAPL on 02/05/22.
//

import UIKit
import iProgressHUD

class TransferViewController: UIViewController {

    @IBOutlet weak var txtPayee: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtDesc: UITextView!
    @IBOutlet weak var btnTransferNow: UIButton!
    @IBOutlet weak var lblPlaceAmount: UILabel!
    @IBOutlet weak var lblPlaceDesc: UILabel!
    @IBOutlet weak var lblErrorAmount: UILabel!
    @IBOutlet weak var centerYPlaceAmount: NSLayoutConstraint!
    @IBOutlet weak var leadPlaceAmount: NSLayoutConstraint!
    @IBOutlet weak var topPlaceDesc: NSLayoutConstraint!
    @IBOutlet weak var leadPlaceDesc: NSLayoutConstraint!
    @IBOutlet weak var lblErrorDesc: UILabel!
    
    let pickerView = UIPickerView()
    var dataPayees = [[String : String]]()
    var token : String = ""
    var strInputAmount : String = ""
    
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
        
        
        self.txtPayee.layer.borderWidth = 1
        self.txtPayee.layer.borderColor = UIColor.gray.cgColor
        self.txtPayee.layer.cornerRadius = 5
        self.lblPlaceAmount.text = "Amount"
        self.lblPlaceAmount.alpha = 0.5
        self.txtAmount.layer.borderWidth = 1
        self.txtAmount.layer.borderColor = UIColor.gray.cgColor
        self.txtAmount.layer.cornerRadius = 5
        self.lblPlaceDesc.text = "Description"
        self.lblPlaceDesc.alpha = 0.5
        self.txtDesc.layer.borderWidth = 1
        self.txtDesc.layer.borderColor = UIColor.gray.cgColor
        self.txtDesc.layer.cornerRadius = 5
        self.txtDesc.backgroundColor = .white
        self.txtAmount.text = "$0.00"
        self.lblErrorAmount.text = ""
        self.lblErrorDesc.text = ""
        
        self.btnTransferNow.layer.cornerRadius = 5
        self.txtAmount.textAlignment = .right
        
        self.pickerView.delegate = self
        self.txtPayee.inputView = pickerView
        self.txtAmount.delegate = self
        self.txtDesc.delegate = self
        
        //get data payees
        WebServices.getPayees(token: self.token) { dataPayeess, status in
            if status!
            {
                if dataPayeess != nil
                {
                    self.dataPayees = dataPayeess ?? [[String : String]]()
                    if self.dataPayees.count > 0
                    {
                        self.txtPayee.text = self.dataPayees[0]["accountNo"] ?? ""
                    }
                }
            }
        }
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
    
    
    @IBAction func doTransferNow(_ sender: Any) {
        let accNo = self.txtPayee.text?.trimmingCharacters(in: .whitespaces) ?? ""
        var stramount = self.txtAmount.text?.trimmingCharacters(in: .whitespaces) ?? ""
        if let i = stramount.firstIndex(of: "$") {
            stramount.remove(at: i)
        }
        let desc = self.txtDesc.text.trimmingCharacters(in: .whitespaces)
        
        self.lblErrorAmount.text = ""
        self.lblErrorDesc.text = ""
        var isOK = true
        
        if stramount == ""
        {
            self.lblErrorAmount.text = "Amount is required"
            isOK = false
        }
        if desc == ""
        {
            self.lblErrorDesc.text = "Description is required"
            isOK = false
        }
        
        if isOK
        {
            CustomConfirm(title: "", msg: "Continue process?", view: self, align: .center) {
                WebServices.doTransfer(accountNo: accNo, amount: stramount, desc: desc, token: self.token) { status, msg in
                    if status!
                    {
                        CustomAlertCallback(title: "", msg: "Success", view: self, align: .center) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else
                    {
                        CustomAlert(title: "", msg: msg!, view: self, align: .center)
                    }
                }
            }
        }
        
        
    }
    
}

extension TransferViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataPayees.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let payee = self.dataPayees[row]
        let p_accno = payee["accountNo"] ?? ""
        let p_accho = payee["name"] ?? ""
        let retval = "\(p_accno) - \(p_accho)"
        
        return retval
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let payee = self.dataPayees[row]
        let p_accno = payee["accountNo"] ?? ""
        //let p_accho = payee["name"] ?? ""
        
        self.txtPayee.text = "\(p_accno)"
    }
    
}

extension TransferViewController: UITextFieldDelegate {
    
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
          return textField.resignFirstResponder()
      }

      func textFieldDidBeginEditing(_ textField: UITextField) {
          if textField == self.txtAmount
          {
              self.centerYPlaceAmount.constant = -30
              self.leadPlaceAmount.constant = -30
          }
          
          performAnimation(transform: CGAffineTransform(scaleX: 0.8, y: 0.8),textField: textField)
      }

      func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            if textField == self.txtAmount
            {
                self.centerYPlaceAmount.constant = 0
                self.leadPlaceAmount.constant = 5
            }

            performAnimation(transform: CGAffineTransform(scaleX: 1, y: 1),textField: textField)
        }
      }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtAmount {
            switch string {
                case "0","1","2","3","4","5","6","7","8","9":
                    self.strInputAmount += string
                    textField.text = formatCurrency(string: self.strInputAmount)
                default:
                if string.count == 0 && self.strInputAmount.count != 0 {
                        self.strInputAmount = String(self.strInputAmount.dropLast())
                        textField.text = formatCurrency(string: self.strInputAmount)
                    }
            }
            
        }
        
        return false
    }
    
    fileprivate func performAnimation(transform: CGAffineTransform,textField: UITextField) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if textField == self.txtAmount
            {
                self.lblPlaceAmount.transform = transform
                self.lblPlaceAmount.layoutIfNeeded()
            }

        }, completion: nil)
    }
    
    
}

extension TransferViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.txtDesc
        {
            self.topPlaceDesc.constant = -20
            self.leadPlaceDesc.constant = -30
        }
        performAnimationTextview(transform: CGAffineTransform(scaleX: 0.8, y: 0.8),textView: textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text, text.isEmpty {
            if textView == self.txtDesc
            {
                self.topPlaceDesc.constant = 10
                self.leadPlaceDesc.constant = 5
            }

            performAnimationTextview(transform: CGAffineTransform(scaleX: 1, y: 1),textView: textView)
        }
    }
    
    fileprivate func performAnimationTextview(transform: CGAffineTransform,textView: UITextView) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            if textView == self.txtDesc{
                self.lblPlaceDesc.transform = transform
                self.lblPlaceDesc.layoutIfNeeded()
            }
        }, completion: nil)
    }
}
