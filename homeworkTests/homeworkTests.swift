//
//  homeworkTests.swift
//  homeworkTests
//
//  Created by MACPRO-ITAPL on 01/05/22.
//

import XCTest
@testable import homework

class homeworkTests: XCTestCase {

    var homeworkService : WebServices.Type!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        self.homeworkService = WebServices.self
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.homeworkService = nil
        try super.tearDownWithError()
    }

    func testWebServices_canLogin() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let t_username : String = "yos"
        let t_password : String = "abcd"
        var isLoggedIn : Bool = false
        let expectation = self.expectation(description: "Login")
        
        self.homeworkService.checkLogin(username: t_username, password: t_password) { status, token, msg in
            isLoggedIn = status ?? false
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertTrue(isLoggedIn, "Successfully Login")
    }
    
    func testWebservices_invalidCredential() -> Void {
        let t_username : String = "yoz"
        let t_password : String = "asdasds"
        var isLoggedIn : Bool = false
        var msg : String = ""
        let expectation = self.expectation(description: "Login")
        
        self.homeworkService.checkLogin(username: t_username, password: t_password) { status, token, msgg in
            isLoggedIn = status ?? false
            msg = msgg ?? ""
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertFalse(isLoggedIn, msg)
    }
    
    func testWebservices_userNotFound() -> Void {
        let t_username : String = "yozzzzzz"
        let t_password : String = "asdasd"
        var isLoggedIn : Bool = false
        var msg : String = ""
        let expectation = self.expectation(description: "Login")
        
        self.homeworkService.checkLogin(username: t_username, password: t_password) { status, token, msgg in
            isLoggedIn = status ?? false
            msg = msgg ?? ""
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertFalse(isLoggedIn, msg)
    }
    
    func testWebServices_canGetBalanceAndAccNo() throws {
        let t_username : String = "yoz"
        let t_password : String = "asdasd"
        var balance : Double = 0
        var accNo : String = ""
        let expectation = self.expectation(description: "Get balance")
        
        self.homeworkService.checkLogin(username: t_username, password: t_password) { status, token, msg in
            if status!
            {
                if token != ""
                {
                    self.homeworkService.getBalance(username: t_username, token: token!) { user, status2 in
                        if status2! {
                            if user != nil {
                                balance = user?.balance ?? 0
                                accNo = user?.accountno ?? ""
                                expectation.fulfill()
                            }
                        }
                    }
                }
                
            }
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertTrue(balance > 0 && accNo != "", "Successfully get data balance and account number")
    }
    
    func testWebServices_canGetTransactionHistory() throws {
        let t_username : String = "yoz"
        let t_password : String = "asdasd"
        var dataTrans = [[String : Any]]()
        let expectation = self.expectation(description: "Get data history")
        
        self.homeworkService.checkLogin(username: t_username, password: t_password) { status, token, msg in
            if status!
            {
                if token != ""
                {
                    self.homeworkService.getTransactions(token: token!) { dataTrans2, status2 in
                        if status2! {
                            dataTrans = dataTrans2!
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 10)
        
        XCTAssertNotNil(dataTrans, "Successfully get data transaction history")
    }
    
    func testWebServices_canRegister() throws {
        let t_username : String = "yoss" //change to yosss if you want to exec this test case again
        let t_password : String = "asdasd"
        var isSuccess : Bool = false
        let expectation = self.expectation(description: "Register")
        
        let user = User(username: t_username, accountno: "", balance: 0, password: t_password)
        self.homeworkService.doRegister(user: user) { status, msg in
            isSuccess = status ?? false
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertTrue(isSuccess, "Successfully Register")
    }
    
    func testWebServices_registerWithSameUsername() throws {
        let t_username : String = "yos"
        let t_password : String = "asdasd"
        var isSuccess : Bool = false
        var msg : String = ""
        let expectation = self.expectation(description: "Register")
        
        let user = User(username: t_username, accountno: "", balance: 0, password: t_password)
        self.homeworkService.doRegister(user: user) { status, msgg in
            isSuccess = status ?? false
            msg = msgg ?? ""
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertFalse(isSuccess, msg)
    }
    
    func testWebServices_canGetPayees() throws {
        let t_username : String = "yoz"
        let t_password : String = "asdasd"
        var dataPayees = [[String : String]]()
        let expectation = self.expectation(description: "Get data payees")
        
        self.homeworkService.checkLogin(username: t_username, password: t_password) { status, token, msg in
            if status!
            {
                if token != ""
                {
                    self.homeworkService.getPayees(token: token!) { dataPayees2, status2 in
                        if status2!
                        {
                            dataPayees = dataPayees2!
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 5)
        XCTAssertNotNil(dataPayees, "Successfully get data payees")
    }
    
    func testWebServices_canMakeTransfer() throws {
        let t_username : String = "yoz"
        let t_password : String = "asdasd"
        let receiver_accno : String = "7174-429-2937"
        let amount : String = "10"
        let desc : String = "testing transfer"
        let expectation = self.expectation(description: "Make Transfer")
        var isSuccess : Bool = false
        
        self.homeworkService.checkLogin(username: t_username, password: t_password) { status, token, msg in
            if status!
            {
                if token != ""
                {
                    self.homeworkService.doTransfer(accountNo: receiver_accno, amount: amount, desc: desc, token: token!) { status2, msg2 in
                        if status2!
                        {
                            isSuccess = true
                            expectation.fulfill()
                        }
                    }
                }
            }
        }
        wait(for: [expectation], timeout: 5)
        
        XCTAssertTrue(isSuccess, "Successfully make transfer")
    }

}
