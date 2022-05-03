//
//  helper.swift
//  homework
//
//  Created by MACPRO-ITAPL on 02/05/22.
//

import Foundation
import UIKit

func CustomAlert(title : String, msg : String, view : UIViewController, align : NSTextAlignment) -> Void {
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = align
    paragraphStyle.headIndent = 13.0
    
    let attributedString = NSAttributedString(string: title, attributes: [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18), //your font here
        NSAttributedString.Key.foregroundColor : UIColor.white
        ])
    let attributedMsgString = NSAttributedString(string: msg, attributes: [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.paragraphStyle : paragraphStyle
        ])
    
    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
    alert.setValue(attributedString, forKey: "attributedTitle")
    alert.setValue(attributedMsgString, forKey: "attributedMessage")
    alert.view.layoutIfNeeded()
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
        //print("Handle Ok logic here")
        
    })
    alert.addAction(ok)
    
    view.present(alert, animated: true, completion: nil)
    
    let subview = alert.view.subviews.first?.subviews.first?.subviews.last
    subview?.layer.cornerRadius = 5.0
    subview?.backgroundColor = UIColor(red: (24/255.0), green: (114/255.0), blue: (89/255.0), alpha: 1.0)
    alert.view.tintColor = UIColor.white
}

func CustomAlertCallback(title : String, msg : String, view : UIViewController, align : NSTextAlignment, actionClosure: @escaping () -> Void) -> Void {
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = align
    paragraphStyle.headIndent = 13.0
    
    let attributedString = NSAttributedString(string: title, attributes: [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18), //your font here
        NSAttributedString.Key.foregroundColor : UIColor.white
        ])
    let attributedMsgString = NSAttributedString(string: msg, attributes: [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.paragraphStyle : paragraphStyle
        ])
    
    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
    alert.setValue(attributedString, forKey: "attributedTitle")
    alert.setValue(attributedMsgString, forKey: "attributedMessage")
    alert.view.layoutIfNeeded()
    let ok = UIAlertAction(title: "OK", style: .cancel, handler: { (action: UIAlertAction!) in
        //print("Handle Ok logic here")
        actionClosure()
    })
    alert.addAction(ok)
    
    view.present(alert, animated: true, completion: nil)
    
    let subview = alert.view.subviews.first?.subviews.first?.subviews.last
    subview?.layer.cornerRadius = 5.0
    subview?.backgroundColor = UIColor(red: (54/255.0), green: (122/255.0), blue: (132/255.0), alpha: 1.0)
    alert.view.tintColor = UIColor.white
}

func CustomConfirm(title : String, msg : String, view : UIViewController, align : NSTextAlignment, actionClosure: @escaping () -> Void) -> Void {
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = align
    paragraphStyle.headIndent = 13.0
    
    let attributedString = NSAttributedString(string: title, attributes: [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18), //your font here
        NSAttributedString.Key.foregroundColor : UIColor.white
        ])
    let attributedMsgString = NSAttributedString(string: msg, attributes: [
        NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.paragraphStyle : paragraphStyle
        ])
    
    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
    alert.setValue(attributedString, forKey: "attributedTitle")
    alert.setValue(attributedMsgString, forKey: "attributedMessage")
    alert.view.layoutIfNeeded()
    let cancel = UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action: UIAlertAction!) in
        //print("Handle Ok logic here")
    })
    let ok = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
        actionClosure()
    }
    alert.addAction(cancel)
    alert.addAction(ok)
    
    view.present(alert, animated: true, completion: nil)
    let subview = alert.view.subviews.first?.subviews.first?.subviews.last
    subview?.layer.cornerRadius = 5.0
    subview?.backgroundColor = UIColor(red: (24/255.0), green: (114/255.0), blue: (89/255.0), alpha: 1.0)
    alert.view.tintColor = UIColor.white
}

func ConvertStrToFormattedDate(str : String) -> String {
    let arrMonth = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    let arrStr = str.components(separatedBy: "-")
    let year = arrStr[0]
    let month = arrMonth[Int(arrStr[1])!-1]
    let day = arrStr[2]
    
    let returnStr = "\(day) \(month) \(year)"
    
    return returnStr
}

func formatCurrency(string: String) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = NSLocale(localeIdentifier: "en_SG") as Locale
    let numberFromField = (NSString(string: string).doubleValue)/100
    let retval = formatter.string(from: NSNumber(value: numberFromField)) ?? ""
    return retval
}
