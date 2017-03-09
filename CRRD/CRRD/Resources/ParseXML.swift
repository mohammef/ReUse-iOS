//
//  ParseXML.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/07/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import CoreData


//Parses XML representation of database and returns array of business objects containing content of XML file
class ParseXML: NSObject, XMLParserDelegate {
    
    private var businessList: [Business] = []
    private var tmpBusiness = Business()
    private var tmpCategory =  Category()
    private var tmpLink = Link()
    private var topElement = ""
    private var currentContent = ""
    private var recycleBusiness = false
    private var newDbVersion = ""
    
    //Gets the strings stored in the Strings.plist file
    private var strings: [String: Any] = Utils.getStrings()
    override init() {}
    
    
    //Parse XML file containing database data
    func parseXMLFile(_ fileName: String) -> (String, [Business]) {
        
        //let xmlFile = Bundle.main.url(forResource: fileName, withExtension: ".xml")
        var fileURL = ""
        
        if fileName == "recycleXML" {
            //Recycle XML file
            fileURL = strings["APIRecycle"] as! String
            recycleBusiness = true
        } else {
            //reuse XML file
            fileURL = strings["APIBusiness"] as! String
        }
        
        //Get XML file from using URL
        let xmlFile = NSURL(string: fileURL)
        print("XML FIle: \(xmlFile)")
        
        //Initialize and start parsing
        let parser = XMLParser(contentsOf: xmlFile! as URL)
        parser?.delegate = self
        parser?.parse()
        
        return (newDbVersion,businessList) //Contains parsed XML file as Business objects
    }
    
    
    //Start of element tag
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        //Handle different cases for start of business, category and link tags
        switch elementName {
        case "business":
            topElement = elementName
            tmpBusiness = Business()
            if recycleBusiness { tmpBusiness.recycleBusiness = true }
        case "category":
            topElement = elementName
            tmpCategory = Category()
        case "link":
            topElement = elementName
            tmpLink = Link()
        case "Revision":
            newDbVersion = ""
        default: break
        }
        currentContent = ""
    }
    
    
    //Append all content found between tags to currentContent
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentContent += string
    }
    
    
    //End of element tag found
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //End of Revision tag
        if elementName == "Revision" {
            newDbVersion = currentContent
            
            //Check for a newer versio of the database
            if UpdateDataModel.checkDbVersion(newDbVersion) {
                
                print("No DB update. Stop parsing DB version: \(newDbVersion)")
                //Same database. Stop parsing XML file
                parser.abortParsing()
            } else {
                //New database. Clear all records and continue parsing XML file
                UpdateDataModel.clearAllRecords()
            }
        }
        
        //End of business tag
        if topElement == "business" {
            
            //Place content at each tag in correct location inside temp Business object
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
            case "business": //End of business
                let business  = Business(tmpBusiness)
                businessList.append(business)
            default: break
            }
        }
        
        //End of category tag
        if topElement == "category" {
            
            //Place content between each tag in correct location inside Category object
            switch elementName {
            case "name":
                tmpCategory.name = currentContent
            case "subcategory":
                var tmpSubCategory = String()
                tmpSubCategory = currentContent
                tmpCategory.subcategoryList.append(tmpSubCategory)
            case "category": //End of category
                topElement = "business"
                let category = Category(category: tmpCategory)
                tmpBusiness.categoryList.append(category)
            default: break
            }
        }
        
        //End of link tag
        if topElement == "link" {
            //Place content between each tag in correct location inside Link object
            switch elementName {
            case "name":
                tmpLink.name = currentContent
            case "URI":
                tmpLink.uri = currentContent
            case "link": //End of link
                topElement = "business"
                let link = Link(link: tmpLink)
                tmpBusiness.linkList.append(link)
            default: break
            }
        }
    }
    
    /*
    //End of XML document
    func parserDidEndDocument(_ parser: XMLParser) {
        printBusinessList()
    }
    
    
    //For Testing
    func printBusinessList() {
        var count = 0
        for item in businessList {
            print("************ Business \(count) ************")
            item.printBusinessDetails()
            print("******************* End *******************\n")
            count += 1
        }
    }
     */

}
