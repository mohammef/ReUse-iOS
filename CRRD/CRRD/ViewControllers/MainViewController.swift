//
//  MainViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 Fahmy Mohammed - Team Reticulum. All rights reserved.
//

import UIKit


class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet var mainView: UIView!
    @IBOutlet weak var applicationNameLong: UILabel!
    @IBOutlet weak var applicationDescription: UILabel!
    @IBOutlet weak var repairButton: UIButton!
    @IBOutlet weak var reuseButton: UIButton!
    @IBOutlet weak var recycleButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        repairButton.layer.cornerRadius = 5
        reuseButton.layer.cornerRadius = 5
        recycleButton.layer.cornerRadius = 5
        
        //Hide back button from the navigation bar
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
  
    //Button action that displays the drop down menu
    @IBAction func dropDownMenu(_ sender: UIBarButtonItem) {
        
        //Reference to drop down menu view controller
        let dropDownView = (storyboard?.instantiateViewController(withIdentifier: "DropDownMenuViewController"))!
        
        //Set presentation style to popover
        dropDownView.modalPresentationStyle = UIModalPresentationStyle.popover
        
        //Setup popover presentation controller
        dropDownView.popoverPresentationController?.delegate = self
        dropDownView.popoverPresentationController?.barButtonItem = sender

        //Present the popover menu
        self.present(dropDownView, animated: false, completion: nil)
    }
    

    
    //UIPopoverPresentationController Delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    //Segue destination for other view controlers to navigate to this view
    //Used by home button on every view
    @IBAction func unwindToMainViewController(segue: UIStoryboardSegue) {

    }
    
}

