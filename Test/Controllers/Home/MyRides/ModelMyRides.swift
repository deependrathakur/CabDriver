//
//  ModelMyRides.swift
//  Test
//
//  Created by Harshit on 07/03/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import GooglePlaces
import Firebase

class ModelMyRides: NSObject {
    var acceptedData = ""
    var cabId = ""
    var busy = false
    var bookLaterDate = ""
    var cancelDate = ""
    var completedDate = ""
    var createdData = ""
    var driver = ""
    var otp = ""
    var id = ""
    var paymentId = ""
    var pickupAddress = ""
    var dropAddress = ""
    var pickupLocation:GeoPoint?
    var dropLocation:GeoPoint?
    var rattingStar = 0
    var reachedDate = ""
    var review = false
    var rideNow = false
    var totalDistanceKM = 0.0
    var totalTimeMinute = "0"
    var userId = ""
    var amount = ""
    var date = ""
    var driveId = ""
    var driverId = ""
    var geopoint:GeoPoint?
    var km = ""
    var reviewComment = ""
    var reviewStar = ""
    var status = ""
    var bookingId = ""
    var tax = ""
    
    init(dict: [String : Any]) {
        amount = dictToStringKeyParam(dict: dict, key: "amount")
        date = dictToStringKeyParam(dict: dict, key: "date")
        driveId = dictToStringKeyParam(dict: dict, key: "driveId")
        driverId = dictToStringKeyParam(dict: dict, key: "driverId")
        geopoint  = dictToGeoPointKeyParam(dict: dict, key: "geopoint")
        km = dictToStringKeyParam(dict: dict, key: "km")
        reviewComment = dictToStringKeyParam(dict: dict, key: "reviewComment")
        reviewStar = dictToStringKeyParam(dict: dict, key: "reviewStar")
        status = dictToStringKeyParam(dict: dict, key: "status")
        tax = dictToStringKeyParam(dict: dict, key: "tax")
        bookingId = dictToStringKeyParam(dict: dict, key: "bookingId")
        acceptedData = dictToStringKeyParam(dict: dict, key: "acceptedData")
        cabId = dictToStringKeyParam(dict: dict, key: "cabId")
        busy = dictToBoolKeyParam(dict: dict, key: "busy")
        bookLaterDate = dictToStringKeyParam(dict: dict, key: "bookLaterDate")
        cancelDate = dictToStringKeyParam(dict: dict, key: "cancelDate")
        completedDate = dictToStringKeyParam(dict: dict, key: "completedDate")
        createdData = dictToStringKeyParam(dict: dict, key: "createdData")
        driver = dictToStringKeyParam(dict: dict, key: "driver")
        otp = dictToStringKeyParam(dict: dict, key: "otp")
        id = dictToStringKeyParam(dict: dict, key: "id")
        paymentId = dictToStringKeyParam(dict: dict, key: "paymentId")
        pickupAddress = dictToStringKeyParam(dict: dict, key: "pickupAddress")
        dropAddress = dictToStringKeyParam(dict: dict, key: "dropAddress")
        pickupLocation = dictToGeoPointKeyParam(dict: dict, key: "pickupLocation")
        dropLocation = dictToGeoPointKeyParam(dict: dict, key: "dropLocation")
        rattingStar = dictToIntKeyParam(dict: dict, key: "rattingStar")
        reachedDate = dictToStringKeyParam(dict: dict, key: "reachedDate")
        review = dictToBoolKeyParam(dict: dict, key: "review")
        rideNow = dictToBoolKeyParam(dict: dict, key: "rideNow")
        totalDistanceKM = dictToDoubleKeyParam(dict: dict, key: "totalDistanceKM")
        totalTimeMinute = dictToStringKeyParam(dict: dict, key: "totalTimeMinute")
        userId = dictToStringKeyParam(dict: dict, key: "userId")
    }
}
