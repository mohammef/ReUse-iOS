//
//  Business.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/07/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit

//Model for business
class Business: NSObject {
    
    var name: String! = nil
    var database_id: Int! = nil
    var address_1: String! = nil
    var address_2: String! = nil
    var city: String! = nil
    var state: String! = nil
    var zip: Int! = nil
    var phone: String! = nil
    var website: String! = nil
    var latitude: Double! = nil
    var longitude: Double! = nil
    var recycleBusiness = false
    var categoryList: [Category] = []
    var linkList: [Link] = []
    
    override init(){}
    
    init(_ name: String,_ database_id: Int,_ address_1: String,_ address_2: String, _ city: String,_ state: String,_ zip: Int,_ phone: String,_ website: String, _ latitude: Double,_ longitude: Double,_ recycleBusiness: Bool, _ categoryList: [Category],_ linkList: [Link]) {
        self.name = name
        self.database_id = database_id
        self.address_1 = address_1
        self.address_2 = address_2
        self.city = city
        self.state = state
        self.zip = zip
        self.phone = phone
        self.website = website
        self.latitude = latitude
        self.longitude = longitude
        self.recycleBusiness = recycleBusiness
        self.categoryList = categoryList
        self.linkList = linkList
    }
    
    init(_ business: Business) {
        self.name = business.name
        self.database_id = business.database_id
        self.address_1 = business.address_1
        self.address_2 = business.address_2
        self.city = business.city
        self.state = business.state
        self.zip = business.zip
        self.phone = business.phone
        self.website = business.website
        self.latitude = business.latitude
        self.longitude = business.longitude
        self.recycleBusiness = business.recycleBusiness
        self.categoryList = business.categoryList
        self.linkList = business.linkList
    }
    

    //For Testing
    /*
    func printBusinessDetails() {
        
        print("-----------------------------------")
        print("name: " + self.name)
        print("id:  \(self.database_id)")
        print("address_1: " + self.address_1)
        print("address_2: " + self.address_2)
        print("city: " + self.city)
        print("state: " + self.state)
        print("zip: \(self.zip)")
        print("phone: " + self.phone)
        print("website: " + self.website)
        print("lat: \(self.latitude)")
        print("long: \(self.longitude)")
        print("is recycle: \(self.recycleBusiness)")
        print("-----------------------------------")
        
        if(self.categoryList.count > 0) {
            for item in self.categoryList {
                print("category name: " + item.name)
                item.printSubCategoryList()
            }
            print("-----------------------------------")
        }
        
        if(self.linkList.count > 0) {
            for item in self.linkList {
                print("link name: " + item.name)
                print(item.uri)
                print("**********")
            }
            print("-----------------------------------")
        }
    }
 */
 
}

