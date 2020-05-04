//
//  ContryCodeVC.swift
//  Test
//
//  Created by Harshit on 04/05/20.
//  Copyright © 2020 Deependra. All rights reserved.
//

import UIKit
import CoreTelephony

protocol CountryCodeDelegate
{  func onSelectCountry(countryCode: String) }

fileprivate class countryCodeData: NSObject {
    
    var countryName : String = ""
    var dialCode : String = ""
    var countryCode : String = ""
    
    init?(data:[String:String]) {
         self.countryName = data["name"] ?? ""
         self.dialCode = data["dial_code"] ?? ""
         self.countryCode = data["code"] ?? ""
    }
}

class CountryCodeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    fileprivate var arrayCountryCode : [countryCodeData] = []
    fileprivate var arrToShow : [countryCodeData] = []
    fileprivate var countryCode: String = ""
    fileprivate var strLocalCCode: String = ""
    fileprivate var otp:String = ""
    
    var delegat:CountryCodeDelegate?
    
    @IBOutlet weak var searchBar : UISearchBar!
    @IBOutlet weak var tblCountryCode : UITableView!
    @IBOutlet weak var lblNoResults : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblCountryCode.delegate = self
        self.tblCountryCode.dataSource = self
        self.customSearchBar()
        self.getCountryCode()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"CountryCodeCell") as! CountryCodeCell
        let objCountry = self.arrToShow[indexPath.row]
        cell.lblCountry?.text = objCountry.countryName
        cell.lblCode?.text = objCountry.dialCode
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let objCountry = self.arrToShow[indexPath.row]
        self.countryCode = objCountry.dialCode
        delegat?.onSelectCountry(countryCode: objCountry.dialCode)
        btnCloseCountryView(0)
    }
}

//MARK: - UISearchBar Delegate
extension CountryCodeVC: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        searchAutocompleteEntries(withSubstring: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        btnCloseCountryView(0)
    }
    
    func searchAutocompleteEntries(withSubstring substring: String) {
        var searchString = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let new = searchString.lowercased(with: Locale(identifier: "en"))
        if searchString.count > 0 {
            arrToShow = arrayCountryCode.filter({ $0.countryName.contains(searchString.uppercased()) || $0.countryName.contains(searchString.lowercased()) || $0.countryName.contains(searchString) || $0.dialCode.contains(searchString) || $0.countryCode.contains(searchString.uppercased()) || $0.countryName.contains(new) || $0.countryName.contains(new.capitalized);
            })
        }else {
            arrToShow = arrayCountryCode
        }
       // self.arrToShow = self.arrToShow.sorted(by: { $0.countryName < $1.countryName })
        self.tblCountryCode.reloadData()
        if arrToShow.count>0 {
            self.lblNoResults.isHidden = true
        }else{
            self.lblNoResults.isHidden = false
        }
    }
}

extension CountryCodeVC {
    //Custom UISearchBar
    func customSearchBar() {
        searchBar.backgroundImage = UIImage()
        searchBar.searchBarStyle = .minimal;
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.font = UIFont.init(name: "museo700", size: 17.0)
        textFieldInsideSearchBar?.textColor = UIColor.white
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        
        let clearButton = textFieldInsideSearchBar?.value(forKey: "_clearButton") as? UIButton
        let templateImage = UIImage.init(named:"clearButton")
        clearButton?.setImage(templateImage,for:.normal)
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor.white
    }
    
    //Get CountryCoads
    func getCountryCode() {
        countryCode = "+1"
        let carrier = CTTelephonyNetworkInfo().subscriberCellularProvider
        
        if (carrier?.isoCountryCode?.uppercased()) != nil{
            strLocalCCode = (carrier?.isoCountryCode?.uppercased())!
        }
        do {
            if let file = Bundle.main.url(forResource:"countrycode", withExtension: "txt") {
                let data = try Data(contentsOf: file)
                let dictData = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let object = dictData as? [String : Any] {
                    if let arr = object["country"] as? [AnyObject] {
                        self.arrayCountryCode = arr.map{countryCodeData(data: $0 as! [String : String])!}
                        for dicCountry in arr{
                            if (dicCountry["code"] as! String == strLocalCCode) {
                                countryCode = (dicCountry["dial_code"] as? String)!
                               // countryCodeField = dicCountry["dial_code"] as? String
                            }
                        }
                    }
                    self.arrToShow = self.arrayCountryCode.sorted(by: { $0.countryName < $1.countryName })
                    self.tblCountryCode.reloadData()
                }
            } else {
            }
        } catch {
        }
    }
    
    @IBAction func btnCloseCountryView(_ sender:Any){
        self.dismiss(animated: true, completion: nil)
    }
}

