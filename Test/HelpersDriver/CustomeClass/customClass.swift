//
//  customBorder.swift
//  MualabBusiness
//
//  Created by Mac on 10/02/2018 .
//  Copyright © 2018 Mindiii. All rights reserved.
//

import UIKit

class viewBorder: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
        }
    }
}

class buttonBorder: UIButton {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
        }
    }
}

class labelBorder: UILabel {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
        }
    }
}
class tableBorder: UITableView {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
        }
    }
}

class textFieldBorder: UITextField {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
        }
    }
}

class textViewBorder: UITextView {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
        }
    }
}

class imageBorder: UIImageView {
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }set {
            layer.cornerRadius = newValue
        }
    }
}

//MARK: Button extension
extension UIButton {
    func buttonCorner(cornerRadius: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    func addBottomLineWithColor(color: UIColor, lineHeight: Int, textColor: UIColor) {
        let bottomView = UIView(frame: CGRect(x: 0, y: Int(self.layer.frame.height), width: Int(self.layer.frame.width), height: lineHeight))
        bottomView.backgroundColor = color
        self.setTitleColor(textColor, for: .normal)
        self.addSubview(bottomView)
    }
}

//MARK: Image extension
extension UIImage {
    func imageIsNull()-> Bool
    {
       let size = CGSize(width: 0, height: 0)
       if (self.size.width == size.width)
        { return true }  else {  return false }
    }
}
//MARK: Image extension
extension UIImageView {
    func imageCorner(cornerRadius: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}

//MARK: View extension
extension UIView {
    func viewBound(){
        self.layer.cornerRadius = self.layer.frame.width/2
        self.layer.masksToBounds = true
    }
}

//MARK: TextField extension
extension UITextField {
    
    func changeTextColor(textColor: UIColor) {
        self.textColor = textColor
    }
    
    func textFieldCorner(cornerRadius: CGFloat){
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
    
    //MARK: - Shake Views
    func shakeTextField() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.10
        animation.repeatCount = 2
        animation.autoreverses = true
        animation.fromValue = CGPoint(x:self.center.x - 7,y:self.center.y)
        animation.toValue = CGPoint(x:self.center.x + 7, y:self.center.y)
        self.layer.add(animation,forKey: "position")
    }
    
    func isValidateEmail() -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: self.text ?? "")
    }
    
    func isEmptyText() -> Bool {
        self.text = self.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return (self.text?.count == 0) ? true : false
    }
}
