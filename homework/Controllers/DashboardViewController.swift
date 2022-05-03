//
//  DashboardViewController.swift
//  homework
//
//  Created by MACPRO-ITAPL on 02/05/22.
//

import UIKit
import iProgressHUD
import FontAwesome_swift

class DashboardViewController: UIViewController {

    @IBOutlet weak var viewSummary: UIView!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblAccNo: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var tblHistory: UITableView!
    @IBOutlet weak var btnTransfer: UIButton!
    var username : String = ""
    var token : String = ""
    var dataTrans = [[String : Any]]()
    var dataTransAll = [String : Any]()
    var dataTransSection = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        iProgressHUD.sharedInstance().attachProgress(toView: self.viewSummary)
        iProgressHUD.sharedInstance().attachProgress(toView: self.tblHistory)
        self.initElement()
    }
    
    func initElement() -> Void {
        
        self.viewSummary.updateCaption(text: "Loading...")
        self.viewSummary.updateIndicator(style: .ballClipRotatePulse)
        self.viewSummary.showProgress()
        self.tblHistory.updateCaption(text: "Loading...")
        self.tblHistory.updateIndicator(style: .ballClipRotatePulse)
        self.tblHistory.showProgress()
        
        self.viewSummary.backgroundColor = .white
        self.viewSummary.clipsToBounds = true
        self.viewSummary.layer.cornerRadius = 10
        self.viewSummary.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMaxXMinYCorner]
        self.viewSummary.layer.shadowColor = UIColor.gray.cgColor
        self.viewSummary.layer.shadowOffset = CGSize.zero
        self.viewSummary.layer.shadowOpacity = 1.0
        self.viewSummary.layer.shadowRadius = 7.0
        self.viewSummary.layer.masksToBounds =  false
        
        self.btnTransfer.layer.cornerRadius = 5
        
        //nav section
        let btnLogout = UIBarButtonItem(title: String.fontAwesomeIcon(name: .signOutAlt), style: UIBarButtonItem.Style.plain, target: self, action: #selector(doLogout))
        let attrBarButton = [
            NSAttributedString.Key.font: UIFont.fontAwesome(ofSize: 20, style: .solid),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        btnLogout.setTitleTextAttributes(attrBarButton, for: .normal)
        
        self.navigationItem.rightBarButtonItem = btnLogout
        self.title = Constants.G_BANK_NAME
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2117647059, green: 0.4784313725, blue: 0.5176470588, alpha: 1 )
        
        //table view section
        self.tblHistory.delegate = self
        self.tblHistory.dataSource = self
        
        WebServices.getBalance(username: self.username, token: self.token) { user, status in
            if status!
            {
                if user != nil
                {
                    let u_balance = user?.balance ?? 0
                    let balance_format = NumberFormatter.localizedString(from: NSNumber(value: u_balance), number: .decimal)
                    let u_accno = user?.accountno ?? ""
                    let u_username = user?.username ?? ""
                    self.lblBalance.text = "SGD \(balance_format)"
                    self.lblAccNo.text = "\(u_accno)"
                    self.lblUsername.text = "\(u_username)"
                }
            }
            self.viewSummary.dismissProgress()
        }
        
        //load data trans history
        WebServices.getTransactions(token: self.token) { dataTrans, statusT in
            if statusT!
            {
                if dataTrans != nil
                {
                    self.dataTrans = dataTrans ?? [[String : Any]]()
                    self.dataTransAll = Dictionary(grouping: self.dataTrans, by: { String(String($0["transactionDate"] as! String).prefix(10))})
                    self.dataTransSection = self.dataTransAll.keys.sorted(by: {$0.localizedStandardCompare($1) == .orderedDescending})
                    if self.dataTransAll.count > 0
                    {
                        self.tblHistory.reloadData()
                    }
                }
            }
            self.tblHistory.dismissProgress()
        }
    }
    
    @objc func doLogout()
    {
        CustomConfirm(title: "", msg: "Continue process?", view: self, align: .center) {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let vcLogin = story.instantiateViewController(withIdentifier: "login_vc") as! LoginViewController
            vcLogin.modalPresentationStyle = .fullScreen
            
            UIApplication.shared.windows.first?.rootViewController = vcLogin
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func doTransfer(_ sender: Any) {
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vcTransfer = story.instantiateViewController(withIdentifier: "transfer_vc") as! TransferViewController
        vcTransfer.modalPresentationStyle = .fullScreen
        vcTransfer.token = token
        
        self.navigationController?.pushViewController(vcTransfer, animated: true)
    }
    
}

extension DashboardViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataTransSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionDate = self.dataTransSection[section]
        let arrayTrans = self.dataTransAll[sectionDate] as! [[String : Any]]
        return arrayTrans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionDate = self.dataTransSection[indexPath.section]
        let arrayTrans = self.dataTransAll[sectionDate] as! [[String : Any]]
        let dataTrans = arrayTrans[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellHistory") as! TransactionTableViewCell
        
        let type = dataTrans["transactionType"] as! String
        var accNo : String = ""
        var accHo : String = ""
        var amountColor = UIColor()
        if type == "received"
        {
            let sender = dataTrans["sender"] as! [String:String]
            accNo = sender["accountNo"] ?? ""
            accHo = sender["accountHolder"] ?? ""
            amountColor = UIColor.green
        }
        else
        {
            let recipient = dataTrans["receipient"] as! [String:String]
            accNo = recipient["accountNo"] ?? ""
            accHo = recipient["accountHolder"] ?? ""
            amountColor = UIColor.red
        }
        let amount = dataTrans["amount"] as? Double ?? 0.00
        
        cell.lblPayees.text = "\(accHo)"
        cell.lblAccNo.text = "\(accNo)"
        cell.lblAmount.text = "\(NumberFormatter.localizedString(from: NSNumber(value: amount), number: .decimal))"
        cell.lblAmount.textColor = amountColor
        cell.lblAmount.textAlignment = .right
        cell.backgroundColor = .lightGray
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionDate = self.dataTransSection[section]
        let formattedSectionDate = ConvertStrToFormattedDate(str: sectionDate)
        return formattedSectionDate
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        (view as! UITableViewHeaderFooterView).textLabel?.textColor = UIColor.white
        (view as! UITableViewHeaderFooterView).textLabel?.font = UIFont.systemFont(ofSize: 17)
    }
}

