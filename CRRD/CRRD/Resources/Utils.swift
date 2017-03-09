//
//  Utils.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import Foundation
import UIKit


//Stores misc. functions used throughout app
class Utils {
    
    //Colors used throught the app
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

    //Sets the Navigation bar, status bar and table view appearance
    static func appTheme() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = Utils.Colors.cscGreenDark
        navigationBar.tintColor = UIColor.white
        
        let tableView = UITableView.appearance()
        tableView.estimatedRowHeight = 10
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    static func getStrings() -> [String: Any] {
        
        if let path = Bundle.main.path(forResource: "Strings", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return dict
        }
        return [:]
    }
    
    
}





