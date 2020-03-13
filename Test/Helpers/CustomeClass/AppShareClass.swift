//
//  AppShareClass.swift
//  Test
//
//  Created by Harshit on 27/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//colors
let appColor = #colorLiteral(red: 0.2235200405, green: 0.04756128043, blue: 0.06039769202, alpha: 1)
let grayColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
let whiteColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
let blackColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

//storyboardName
let mainStoryBoard = "Main"
//UIViewController name
let registerVC = "RegisterVC"
let loginVC = "LoginVC"
let otpVC = "OTPVC"
let uploadDocVC = "UploadDocVC"

let homeStoryBoard = "Home"
let HomeNav = "HomeNav"
//UIViewController name
let myRidesVC = "MyRidesVC"
let cabVC = "CabVC"
let waitingForDriverVC = "WaitingForDriverVC"
let writeReviewVC = "WriteReviewVC"
let userProfileVC = "UserProfileVC"
let myMenuVC = "MyMenuVC"

//cell
let myMenuCell = "MyMenuCell"
let cellMyRides = "CellMyRides"

func goToNextVC(storyBoardID: String, vc_id: String, currentVC: UIViewController) {
    let vc = UIStoryboard.init(name: storyBoardID, bundle: Bundle.main).instantiateViewController(withIdentifier: vc_id)
    currentVC.navigationController?.pushViewController(vc, animated: true)
}

func setRevelVC(storyBoardID: String, vc_id: String, currentVC: UIViewController) {
    let sb2 = UIStoryboard.init(name: storyBoardID, bundle:Bundle.main)
    let objChatHistory = sb2.instantiateViewController(withIdentifier: vc_id)
    let navigationcontroller = UINavigationController.init(rootViewController: objChatHistory)
    objChatHistory.navigationController?.navigationBar.isHidden = true
    currentVC.revealViewController().pushFrontViewController(navigationcontroller, animated: true)
}

func getCurrentTimeStampWOMiliseconds(dateToConvert: NSDate) -> String {
    let objDateformat: DateFormatter = DateFormatter()
    objDateformat.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS+00:00"
    let strTime: String = objDateformat.string(from: dateToConvert as Date)
    let objUTCDate: NSDate = objDateformat.date(from: strTime)! as NSDate
    let milliseconds: Int64 = Int64(objUTCDate.timeIntervalSince1970)
    let strTimeStamp: String = "\(milliseconds)"
    return strTimeStamp
}

func getTimeFromTime(date:Date) -> String {
    let formatter  = DateFormatter()
    formatter.dateFormat = "dd MMM yyyy hh:mm a"
    formatter.dateFormat = "MMM DD yyyy hh:mm a"
    formatter.dateFormat = "E, d MMM yyyy hh:mm a"

    formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
    let formatedDate: String = formatter.string(from: date)
    return formatedDate
}

func getDistanceOfTwoPoint(startPoint: String, endPoint: String) -> String {
    let arrStartPoint =  startPoint.components(separatedBy: ",")
    let arrEndPoint =  endPoint.components(separatedBy: ",")
    
    if arrStartPoint.count > 1 && arrEndPoint.count > 1 {
        let a = distance(lat1: Double(arrStartPoint[0])!,
                         lon1: Double(arrStartPoint[1])!,
                         lat2: Double(arrEndPoint[0])!,
                         lon2: Double(arrEndPoint[1])!, unit: "K")
        let doubleStr = String(format: "%.2f", a)
        return doubleStr
    }
    return "0"
}


func getDistanceOfTwoPointInDouble(startPoint: String, endPoint: String) -> Double {
    let arrStartPoint =  startPoint.components(separatedBy: ",")
    let arrEndPoint =  endPoint.components(separatedBy: ",")
    
    if arrStartPoint.count > 1 && arrEndPoint.count > 1 {
        let a = distance(lat1: Double(arrStartPoint[0])!,
                         lon1: Double(arrStartPoint[1])!,
                         lat2: Double(arrEndPoint[0])!,
                         lon2: Double(arrEndPoint[1])!, unit: "K")
        let doubleStr = String(format: "%.2f", a)
        return Double(doubleStr) ?? 0.00
    }
    return 0.00
}

    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        return dist
    }
    
    func deg2rad(deg:Double) -> Double {
        return deg * M_PI / 180
    }

    ///////////////////////////////////////////////////////////////////////
    ///  This function converts radians to decimal degrees              ///
    ///////////////////////////////////////////////////////////////////////
    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / M_PI
    }

////////////////////
func dictToStringKeyParam(dict: [String:Any], key: String) -> String {
    if let value = dict[key] as? String {
        return value
    } else if let value = dict[key] as? Int {
        return String(value)
    } else if let value = dict[key] as? Double {
        return String(value)
    } else if let value = dict[key] as? Float {
        return String(value)
    } else if let stamp = dict[key] as? Timestamp {
        return getTimeFromTime(date: stamp.dateValue())
    } else {
        return ""
    }
}



