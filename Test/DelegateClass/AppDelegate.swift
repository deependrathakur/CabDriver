//
//  AppDelegate.swift
//  Test
//
//  Created by Harshit on 25/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import Firebase
import GooglePlaces
import CoreLocation
import FirebaseAuth
import UserNotifications
import NotificationCenter
import FirebaseMessaging
import FirebaseInstanceID

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var navigationcontroller:UINavigationController?
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
       // GMSPlacesClient.provideAPIKey("AIzaSyCFnmNB2nO-SVKE7-SNf-c5_5tcyJ0J0JI")// from my account generated
       // GMSPlacesClient.provideAPIKey("AIzaSyDxub2Kgfrs4UP4a8DH0FbRHnwRIheOZpI")// info.plist
        GMSPlacesClient.provideAPIKey("AIzaSyDhb3bII6A6O0CCogK08U6aWpExoLmf-aQ")// info.plist
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        self.getCurrentLocation()
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func getUserDetailFromFirebase() {
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            if userId != "" {
            Firestore.firestore().collection("driver").document(userId).getDocument() { (querySnapshot, err) in
                    if let err = err {
                    } else {
                        let document = querySnapshot
                        let dict = document?.data()
                        UserDefaults.standard.set(document?.documentID, forKey: "userId")
                        DictUserDetails = dict
                        modelUserDetail = ModelUserDetail.init(Dict: DictUserDetails ?? ["":""])
                    }
                }
            }
        }
    }
    func getCurrentLocation() {
        self.locationManager.requestAlwaysAuthorization()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let locValue = locationManager.location?.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let distanceFromLastLocation = getDistanceOfTwoPointInGeoPoint(startPoint: GeoPoint.init(latitude: locValue.latitude, longitude: locValue.longitude), endPoint: currentLocationGeoPoint)
        let meter = (distanceFromLastLocation * 1000)
        if meter > 3 {
            currentLocationGeoPoint = GeoPoint.init(latitude: locValue.latitude, longitude: locValue.longitude)
            if let userId = UserDefaults.standard.string(forKey: "userId") {
                if userId != "" {
                    Firestore.firestore().collection("driver").document(userId).updateData(["currentLocation":currentLocationGeoPoint])
                    modelUserDetail = ModelUserDetail.init(Dict: DictUserDetails ?? ["":""])
               }
            }
        }
   }
}

//MARK: Notification method
extension AppDelegate {
    //MARK: - Remote Notification Get Device token methods.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        if deviceTokenString.count > 0 {
            iosDeviceToken = deviceTokenString
        }
        
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID(Token): \(error)")
            }else if let result = result{
                print("Remote instance ID token: \(result.token)")
                firebaseToken = "\(result.token)"
            }
        })
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print message ID.
        //      if let messageID = userInfo[gcm] {
        //        print("Message ID: \(messageID)")
        //      }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ////      // Print message ID.
        //      if let messageID = userInfo[gcmMessageIDKey] {
        //        print("Message ID: \(messageID)")
        //      }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func configureNotification() {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            UNUserNotificationCenter.current().delegate = self
            
            let openAction = UNNotificationAction(identifier: "OpenNotification", title: NSLocalizedString("Abrir", comment: ""), options: UNNotificationActionOptions.foreground)
            let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [openAction], intentIdentifiers: [], options: [])
            center.setNotificationCategories(Set([deafultCategory]))
        } else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
        }
        UIApplication.shared.registerForRemoteNotifications()
    }


    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        firebaseToken = fcmToken
        print("firebaseToken = \(firebaseToken)")
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        firebaseToken = fcmToken
        print("firebaseToken = \(firebaseToken)")
        ConnectToFCM()
    }
    
    func tokenRefreshNotification(_ notification: Notification) {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID(Token): \(error)")
            }else if let result = result{
                print("Remote instance ID token: \(result.token)")
                firebaseToken = "\(result.token)"
            }
        })
        ConnectToFCM()
    }
    
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
    }
    
    func ConnectToFCM() {
        InstanceID.instanceID().instanceID(handler: { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID(Token): \(error)")
            }else if let result = result{
                print("Remote instance ID token: \(result.token)")
                firebaseToken = "\(result.token)"
            }
        })
    }
}
