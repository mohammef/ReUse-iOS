//
//  ParseXML.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/07/17.
//  Copyright © 2017 CS467 F17 - Team Reticulum. All rights reserved.
//

import UIKit
import CoreData

class ParseXML: NSObject, XMLParserDelegate {
    
    private var businessList: [Business] = []
    private var tmpBusiness = Business()
    private var tmpCategory = Category()
    private var tmpLink = Link()
    private var topElement = ""
    private var currentContent = ""
    override init() {}
    
    func parseXMLFile() -> Void{
        let xmlFilePath = Bundle.main.url(forResource: "reuseDB", withExtension: ".xml")
        let parser = XMLParser(contentsOf: xmlFilePath!)
        parser?.delegate = self
        parser?.parse()
    }
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        switch elementName {
        case "business":
            topElement = elementName
            tmpBusiness = Business()
        case "category":
            topElement = elementName
            tmpCategory = Category()
        case "link":
            topElement = elementName
            tmpLink = Link()
        default: break
        }
        currentContent = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentContent += string
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if topElement == "business" {
            switch elementName {
            case "name":
                tmpBusiness.name = currentContent
            case "id":
                tmpBusiness.database_id = Int(currentContent)
            case "address_line_1":
                tmpBusiness.address_1 = currentContent
            case "address_line_2":
                tmpBusiness.address_2 = currentContent
            case "city":
                tmpBusiness.city = currentContent
            case "state":
                tmpBusiness.state = currentContent
            case "zip":
                tmpBusiness.zip = Int(currentContent)
            case "phone":
                tmpBusiness.phone = currentContent
            case "website":
                tmpBusiness.website = currentContent
            case "latitude":
                tmpBusiness.latitude = Double(currentContent)
            case "longitude":
                tmpBusiness.longitude = Double(currentContent)
            case "business":
                let business  = Business(business: tmpBusiness)
                businessList.append(business)
            default: break
            }
        }
        
        
        if topElement == "category" {
            switch elementName {
            case "name":
                tmpCategory.name = currentContent
            case "subcategory":
                var tmpSubCategory = String()
                tmpSubCategory = currentContent
                tmpCategory.subcategoryList.append(tmpSubCategory)
            case "category":
                topElement = "business"
                let category = Category(category: tmpCategory)
                tmpBusiness.categoryList.append(category)
            default: break
            }
        }
        
        if topElement == "link" {
            switch elementName {
            case "name":
                tmpLink.name = currentContent
            case "URI":
                tmpLink.uri = currentContent
            case "link":
                topElement = "business"
                let link = Link(link: tmpLink)
                tmpBusiness.linkList.append(link)
            default: break
            }
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        printBusinessList()
    }
    
    func printBusinessList() {
        var count = 0
        for item in businessList {
            print("************ Business \(count) ************")
            item.printBusinessDetails()
            print("******************* End *******************\n")
            count += 1
        }
    }
    
    
}
