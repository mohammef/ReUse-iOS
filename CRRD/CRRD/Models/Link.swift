//
//  Link.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/07/17.
//  Copyright © 2017 CS467 F17 - Team Reticulum. All rights reserved.
//

import UIKit

class Link: NSObject {
    
    var name: String! = nil
    var uri: String! = nil
    
    override init(){}
    
    init(name: String, uri: String) {
        self.name = name
        self.uri = uri
    }
    
    init(link: Link) {
        self.name = link.name
        self.uri = link.uri
    }
}
