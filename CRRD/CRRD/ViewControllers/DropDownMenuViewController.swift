//
//  DropDownMenuViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 CS467 F17 - Team Reticulum. All rights reserved.
//

import UIKit

class DropDownMenuViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Navigation
    
    //Action that is run when about button is clicked
    //Dismisses the drop down menu and navigates to the AboutViewController
    @IBAction func aboutButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil) //Dismiss drop down menu
        
        //Perform segue to AboutViewController from presenting view Controller
        //The presentingViewController is the root navigation controller since the drop down menu
        //is anchored to a navigation bar button
        self.presentingViewController!.performSegue(withIdentifier: "showAbout", sender: self)
    }

    //Action that is run when contact button is clicked
    //Dismisses the drop down menu and navigates to the ContactViewController
    @IBAction func contactButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil) //Dismiss drop down menu
        
        //Perform segue to ContactViewController from presenting view Controller
        //The presentingViewController is the root navigation controller since the drop down menu
        //is anchored to a navigation bar button
        self.presentingViewController!.performSegue(withIdentifier: "showContact", sender: self)
    }

}
