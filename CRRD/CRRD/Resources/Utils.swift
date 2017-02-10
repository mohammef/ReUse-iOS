//
//  Utils.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 Fahmy Mohammed - Team Reticulum. All rights reserved.
//

import Foundation
import UIKit



class Utils {
    struct Colors {
        static func UIColorFromRGB(rgbValue: UInt) -> UIColor {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
            
        }
        
        static let cscGreen = UIColorFromRGB(rgbValue: 0x7C903A)
        static let cscGreenLight = UIColorFromRGB(rgbValue: 0x99B247)
        static let cscGreenDark = UIColorFromRGB(rgbValue: 0x4F5C25)
        static let cscOrange = UIColorFromRGB(rgbValue: 0xF89420)
        static let cscBlue = UIColorFromRGB(rgbValue: 0x47A6B2)
        static let cscBlueDark = UIColorFromRGB(rgbValue: 0x415E5E)
       
    }
    
    struct Styles {
        static let labelFontMain = UIFont(name: "ArialMT" , size: 40.0)
        static let labelFont = UIFont(name: "ArialMT" , size: 15.0)
        static let mainButtonFont = UIFont(name: "ArialMT" , size: 20.0)
    
        static let roundedButtonCornerRadius: CGFloat = 5.0
        
    }
    
    static func appTheme() {
        
        //let navigationBar = UINavigationBar.appearance()
        
        
        let view = UIView.appearance()
        view.backgroundColor = Colors.cscGreenLight
    
        let button = UIButton.appearance()
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Colors.cscGreenDark
        button.layer.cornerRadius = Styles.roundedButtonCornerRadius
        
        let label = UILabel.appearance()
        //labelMain.font = Styles.labelFontMain
        label.textColor = UIColor.black
        
    }
    
}





