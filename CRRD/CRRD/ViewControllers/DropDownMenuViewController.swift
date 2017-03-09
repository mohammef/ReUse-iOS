//
//  DropDownMenuViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit

class DropDownMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    /*****************************************************************************/
    //MARK: - Navigation
    
    //Action that is run when about button is clicked
    @IBAction func aboutButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil) //Dismiss drop down menu
        
        //Perform segue to AboutViewController from presenting view Controller
        //The presentingViewController is the root navigation controller 
        self.presentingViewController!.performSegue(withIdentifier: "showAbout", sender: self)
    }

    //Action that is run when contact button is clicked
    @IBAction func contactButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil) //Dismiss drop down menu
        
        //Perform segue to ContactViewController from presenting view Controller
        //The presentingViewController is the root navigation controller
        self.presentingViewController!.performSegue(withIdentifier: "showContact", sender: self)
    }
}
