//
//  ModelMyRides.swift
//  Test
//
//  Created by Harshit on 07/03/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit

class ModelMyRides: NSObject {
    var amount = ""
    var date = ""
    var driveId = ""
    var driverId = ""
    var drop = ""
    var dropPoint = ""
    var geopoint  = ""
    var km = ""
    var pickup = ""
    var pickupPoint = ""
    var reviewComment = ""
    var reviewStar = ""
    var status = ""
    var tax = ""

    init(dict: [String : Any]) {
        amount = dictToStringKeyParam(dict: dict, key: "amount")
        date = dictToStringKeyParam(dict: dict, key: "date")
        driveId = dictToStringKeyParam(dict: dict, key: "driveId")
        driverId = dictToStringKeyParam(dict: dict, key: "driverId")
        drop = dictToStringKeyParam(dict: dict, key: "drop")
        dropPoint = dictToStringKeyParam(dict: dict, key: "dropPoint")
        geopoint  = dictToStringKeyParam(dict: dict, key: "geopoint")
        km = dictToStringKeyParam(dict: dict, key: "km")
        pickup = dictToStringKeyParam(dict: dict, key: "pickup")
        pickupPoint = dictToStringKeyParam(dict: dict, key: "pickupPoint")
        reviewComment = dictToStringKeyParam(dict: dict, key: "reviewComment")
        reviewStar = dictToStringKeyParam(dict: dict, key: "reviewStar")
        status = dictToStringKeyParam(dict: dict, key: "status")
        tax = dictToStringKeyParam(dict: dict, key: "tax")
    }
}
