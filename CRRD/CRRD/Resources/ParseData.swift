//
//  ParseData.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/16/17.
//  Copyright © 2017 CS467 F17 - Team Reticulum. All rights reserved.
//

import Foundation
import CoreData

class ParseData: NSObject, XMLParserDelegate {
    
    private var businessList: [Business] = []
    private var business: Business = Business()
    private var currentElement = ""
    private var currentContent = ""
    
    func parseXMLFile() {
        
        
        let xmlFilePath = Bundle.main.url(forResource: "reuseDB", withExtension: ".xml")
        let parser = XMLParser(contentsOf: xmlFilePath!)
        parser?.delegate = self
        parser?.parse()
        
        
        
        
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        if currentContent == "business" {
            business = Business()
            currentContent = ""
        }
        
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "name":
            business.name = string
        default: break
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "business" {
            businessList.append(business)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        printBusinessList()
    }
    
    func printBusinessList() {
        
        for item in businessList {
            print(item.name)
        }
    }
    
}
