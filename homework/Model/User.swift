//
//  User.swift
//  homework
//
//  Created by MACPRO-ITAPL on 02/05/22.
//

import Foundation

class User {
    var username : String
    var password : String
    var accountno : String
    var balance : Double
    
    init(username: String,accountno: String,balance: Double,password: String) {
        self.username = username
        self.accountno = accountno
        self.balance = balance
        self.password = password
    }
}
