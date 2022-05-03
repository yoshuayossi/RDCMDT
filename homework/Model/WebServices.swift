//
//  WebServices.swift
//  homework
//
//  Created by MACPRO-ITAPL on 02/05/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class WebServices {
    
    static func initstate()
    {
        UserDefaults.standard.set("", forKey: "token")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set("", forKey: "accno")
        UserDefaults.standard.set("", forKey: "username")
    }
    
    static func checkLogin(username: String,password: String,completionHandler: @escaping (Bool?,String?,String?) -> Void)
    {
        let parameter = [
            "username" : username,
            "password" : password
        ]
        
        let httpHeader : HTTPHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json"
        ]
        
        let urlAPI = "\(Constants.G_URL_API)/login"
        
        AF.request(URL(string: urlAPI)!, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: httpHeader, interceptor: nil).responseJSON { (responseAF) in
            //print(responseAF)
            switch responseAF.result {
                case .success :
                    let jsonData = JSON(responseAF.value as Any)
                    let status = jsonData["status"].stringValue
                    if status == "success"
                    {
                        let token = jsonData["token"].stringValue
                        let accno = jsonData["accountNo"].stringValue
                        let username = jsonData["username"].stringValue
                        
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set(accno, forKey: "accno")
                        UserDefaults.standard.set(username, forKey: "username")
                        
                        completionHandler(true,token,"")
                    }
                    else{
                        let msg = jsonData["error"].stringValue
                        completionHandler(false,"",msg)
                    }
                case .failure :
                    let msg = "Check your internet connection"
                    completionHandler(false,"",msg)
            }
        }
    }
    
    static func getBalance(username: String,token: String,completionHandler: @escaping (User?,Bool?) -> Void)
    {
        let parameter = [String:String]()
        
        let httpHeader : HTTPHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json",
            "Authorization" : token
        ]
        
        let urlAPI = "\(Constants.G_URL_API)/balance"
        
        AF.request(URL(string: urlAPI)!, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: httpHeader, interceptor: nil).responseJSON { (responseAF) in
            //print(responseAF)
            switch responseAF.result {
                case .success :
                    let jsonData = JSON(responseAF.value as Any)
                    let status = jsonData["status"].stringValue
                    if status == "success"
                    {
                        let accno = jsonData["accountNo"].stringValue
                        let balance = jsonData["balance"].doubleValue
                        
                        UserDefaults.standard.set(accno, forKey: "accno")
                        UserDefaults.standard.set(balance, forKey: "balance")
                        
                        let user = User(username: username, accountno: accno, balance: balance, password: "")
                        
                        completionHandler(user,true)
                    }
                    else{
                        completionHandler(nil,false)
                    }
                case .failure :
                    completionHandler(nil,false)
            }
        }
    }
    
    static func getTransactions(token: String,completionHandler: @escaping ([[String : Any]]?,Bool?) -> Void)
    {
        let parameter = [String:String]()
        
        let httpHeader : HTTPHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json",
            "Authorization" : token
        ]
        
        let urlAPI = "\(Constants.G_URL_API)/transactions"
        
        AF.request(URL(string: urlAPI)!, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: httpHeader, interceptor: nil).responseJSON { (responseAF) in
            switch responseAF.result {
                case .success :
                    let jsonData = JSON(responseAF.value as Any)
                    let status = jsonData["status"].stringValue
                    if status == "success"
                    {
                        var dataTrans = [[String : Any]]()
                        dataTrans = jsonData["data"].arrayObject as! [[String : Any]]
                        
                        completionHandler(dataTrans,true)
                    }
                    else{
                        completionHandler(nil,false)
                    }
                case .failure :
                    completionHandler(nil,false)
            }
        }
    }
    
    static func getPayees(token: String,completionHandler: @escaping ([[String : String]]?,Bool?) -> Void)
    {
        let parameter = [String:String]()
        
        let httpHeader : HTTPHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json",
            "Authorization" : token
        ]
        
        let urlAPI = "\(Constants.G_URL_API)/payees"
        
        AF.request(URL(string: urlAPI)!, method: .get, parameters: parameter, encoding: URLEncoding.default, headers: httpHeader, interceptor: nil).responseJSON { (responseAF) in
            switch responseAF.result {
                case .success :
                    let jsonData = JSON(responseAF.value as Any)
                    let status = jsonData["status"].stringValue
                    if status == "success"
                    {
                        var dataPayees = [[String : String]]()
                        dataPayees = jsonData["data"].arrayObject as! [[String : String]]
                        
                        completionHandler(dataPayees,true)
                    }
                    else{
                        completionHandler(nil,false)
                    }
                case .failure :
                    completionHandler(nil,false)
            }
        }
    }
    
    static func doTransfer(accountNo: String,amount: String,desc: String,token: String,completionHandler: @escaping (Bool?,String?) -> Void)
    {
        let parameter : [String : Any] = [
            "receipientAccountNo" : accountNo,
            "amount" : Double(amount)!,
            "description" : desc
        ]
        
        let httpHeader : HTTPHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json",
            "Authorization" : token
        ]
        
        let urlAPI = "\(Constants.G_URL_API)/transfer"
        AF.request(URL(string: urlAPI)!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: httpHeader, interceptor: nil).responseJSON { (responseAF) in
            switch responseAF.result {
                case .success :
                    let jsonData = JSON(responseAF.value as Any)
                    let status = jsonData["status"].stringValue
                    if status == "success"
                    {
                        completionHandler(true,"")
                    }
                    else
                    {
                        let msg = jsonData["error"].stringValue
                        completionHandler(false,msg)
                    }
                case .failure :
                    let msg = "Check your internet connection"
                    completionHandler(false,msg)
            }
        }
    }
    
    static func doRegister(user: User,completionHandler: @escaping (Bool?,String?) -> Void)
    {
        let parameter = [
            "username" : user.username,
            "password" : user.password
        ]
        
        let httpHeader : HTTPHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json"
        ]
        
        let urlAPI = "\(Constants.G_URL_API)/register"
        
        AF.request(URL(string: urlAPI)!, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: httpHeader, interceptor: nil).responseJSON { (responseAF) in
            switch responseAF.result {
                case .success :
                    let jsonData = JSON(responseAF.value as Any)
                    let status = jsonData["status"].stringValue
                    if status == "success"
                    {
                        let token = jsonData["token"].stringValue
                        
                        UserDefaults.standard.set(token, forKey: "token")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set("", forKey: "accno")
                        UserDefaults.standard.set(user.username, forKey: "username")
                        
                        completionHandler(true,"")
                    }
                    else{
                        let msg = jsonData["error"].stringValue
                        completionHandler(false,msg)
                    }
                case .failure :
                    let msg = "Check your internet connection"
                    completionHandler(false,msg)
            }
        }
    }
}
