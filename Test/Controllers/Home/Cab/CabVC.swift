//
//  CabeVC.swift
//  Test
//
//  Created by Harshit on 28/02/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces
import Firebase
import GoogleMaps

class CabVC: UIViewController, SWRevealViewControllerDelegate, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet var indicator: UIActivityIndicatorView!
    
    //popup view confirm
    @IBOutlet weak var vwPopup:UIView!
    @IBOutlet weak var btnAvailable:UIButton!

    @IBOutlet weak var lblPrice:UILabel!
    @IBOutlet weak var lblTimeDistance:UILabel!
    
    @IBOutlet weak var txtPicupLocationPopup:UITextField!
    @IBOutlet weak var txtDroupLocationPopup:UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewPopup: MKMapView!
    @IBOutlet weak var menuButton: UIButton!
    
    fileprivate var placeForIndex = 1
    var bookingDict = ModelMyRides(dict: ["":""])
    fileprivate let db = Firestore.firestore()
    fileprivate let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.isHidden = true
        self.getCurrentLocation()
        mapView.delegate = self
        mapViewPopup.delegate = self
        locationManager.delegate = self
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        self.txtPicupLocationPopup.delegate = self
        self.txtDroupLocationPopup.delegate = self

        self.vwPopup.isHidden = true
        menuButton.addTarget(revealViewController, action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.revealViewController().delegate = self
        revealViewController()?.rearViewRevealWidth = 60
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.vwPopup.isHidden = true
        UserDefaults.standard.set(cabVC, forKey: "vc")
        AppDelegate().getUserDetailFromFirebase()
        parseDataInField()
        UserDetails()
    }
    
 // MARK: MKMapViewDelegate
   func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       if let polyline = overlay as? MKPolyline {
           let polylineRenderer = MKPolylineRenderer(overlay: polyline)
           polylineRenderer.strokeColor = .blue
           polylineRenderer.lineWidth = 3
           return polylineRenderer
       }
       return MKOverlayRenderer(overlay: overlay)
   }
    func getDirections(enterdLocations:[String])  {
        // array has the address strings
        var locations = [MKPointAnnotation]()
        for item in enterdLocations {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(item, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                }
                if let placemark = placemarks?.first {

                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate

                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = item
                    self.mapView.addAnnotation(dropPin)
                    self.mapView.selectAnnotation( dropPin, animated: true)

                    locations.append(dropPin)
                    //add this if you want to show them all
                    self.mapView.showAnnotations(locations, animated: true)
                }
            })
        }
    }
}

//MARK: - Custome Method extension
fileprivate extension CabVC {
    func UserDetails() {
        if modelUserDetail?.available == true {
            self.btnAvailable.setTitle("AVAILABLE", for: .normal)
        } else {
            self.btnAvailable.setTitle("UNAVAILABLE", for: .normal)
        }
    }
    
    func parseDataInField() {
        self.txtDroupLocationPopup.text = bookingDict.dropAddress
        self.txtPicupLocationPopup.text = bookingDict.pickupAddress
        self.lblTimeDistance.text = "\(getDistanceInInt()) KM, \(getDistanceInInt()) min"
        self.lblPrice.text = "$\(Double(getDistanceInInt())*2.5)"
        setupMap()
    }
    
    func setupMap() {
        let pickupCoordinate = CLLocationCoordinate2D(latitude: bookingDict.pickupLocation?.latitude ?? commanGeoPoint.latitude, longitude: bookingDict.pickupLocation?.longitude ?? commanGeoPoint.longitude)
        let destinationCoordinate = CLLocationCoordinate2D(latitude: bookingDict.dropLocation?.latitude ?? commanGeoPoint.latitude, longitude: bookingDict.dropLocation?.longitude ?? commanGeoPoint.longitude)
        self.mapView = showRouteOnMap(pickupCoordinate: pickupCoordinate, destinationCoordinate: destinationCoordinate, mapView: mapView)
        self.mapViewPopup = showRouteOnMap(pickupCoordinate:pickupCoordinate, destinationCoordinate: destinationCoordinate, mapView: mapViewPopup)
    }
  
    
    func getDistanceInInt() -> Int {
        let value = getDistanceOfTwoPointInGeoPoint(startPoint: bookingDict.pickupLocation ?? commanGeoPoint, endPoint: bookingDict.dropLocation ?? commanGeoPoint)
        return Int(value)
    }
}

//MARK: - location view extension
extension CabVC : CLLocationManagerDelegate {
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
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        currentLocationGeoPoint = GeoPoint.init(latitude: locValue.latitude, longitude: locValue.longitude)
//    }
//
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        let location = locations.last as! CLLocation
//        currentLocationGeoPoint = GeoPoint.init(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            if bookingDict.pickupAddress == "" || bookingDict.pickupAddress == nil {anView?.image = nil} else {
            anView?.image = #imageLiteral(resourceName: "car5")
            }
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId) as? MKAnnotation
        }
        return anView
    }
}
 
//MARK: - Button Method extension
fileprivate extension CabVC {
    @IBAction func currentLocation(sender: UIButton) {
        let center = CLLocationCoordinate2D(latitude: currentLocationGeoPoint.latitude, longitude: currentLocationGeoPoint.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = mapView.userLocation.coordinate
        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func CancelRideLaterAction(sender: UIButton) {
        self.view.endEditing(true)
        self.vwPopup.isHidden = true
    }
    
    @IBAction func AcceptAction(sender: UIButton) {
        self.view.endEditing(true)
        self.vwPopup.isHidden = true
        setRevelVC(storyBoardID: homeStoryBoard, vc_id: waitingForCustomerVC, currentVC: self)
    }
    
    @IBAction func AvailableBookingAction(sender: UIButton) {
        self.view.endEditing(true)
        if modelUserDetail?.available ?? true {
            modelUserDetail?.available = false
        } else {
            modelUserDetail?.available = true
        }
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            self.db.collection("driver").document(userId).updateData(["available":modelUserDetail?.available ?? true])
        }
        UserDetails()
    }
    
    @IBAction func RejectAction(sender: UIButton) {
        self.view.endEditing(true)
        self.vwPopup.isHidden = true
    }
    
    @IBAction func MenuAction(sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func NotificationAction(sender: UIButton) {
        showAlertVC(title: kAlertTitle, message: WIP, controller: self)
    }
}

// MARK: - ENSideMenu Delegate
extension CabVC {
    func revealController(_ revealController: SWRevealViewController!, didMoveTo position: FrontViewPosition) {
        switch position {
            
        case FrontViewPosition.leftSideMostRemoved:
            print("LeftSideMostRemoved")
            
        case FrontViewPosition.leftSideMost:
            print("LeftSideMost")
            
        case FrontViewPosition.leftSide:
            print("LeftSide")
            
        case FrontViewPosition.left:
            print("Left")
            
        case FrontViewPosition.right:
            print("Right")
            
        case FrontViewPosition.rightMost:
            print("RightMost")
            
        case FrontViewPosition.rightMostRemoved:
            print("RightMostRemoved")
        @unknown default:
            print("Unknown")
        }
    }
    
    func sideMenuWillOpen() {
        self.view.isUserInteractionEnabled=false;
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        self.view.isUserInteractionEnabled=true;
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
}
