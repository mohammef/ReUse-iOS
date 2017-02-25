//
//  AboutViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    @IBOutlet weak var viewLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Theme
    
    //Adjusts look of items in view
    func viewTheme(){
        //Hide back button from the navigation bar
        //self.navigationItem.setHidesBackButton(true, animated: false)
        
        //Set left navigation bar label
        viewLabel.text = "About Corvallis ReUse"
    }
    
    
    //MARK: - Navigation
    
    //Button action that displays the drop down menu
    @IBAction func dropDownMenu(_ sender: UIButton) {
        
        //Reference to drop down menu view controller
        let dropDownView = (storyboard?.instantiateViewController(withIdentifier: "DropDownMenuViewController"))!
    
        //Set presentation style to popover
        dropDownView.modalPresentationStyle = UIModalPresentationStyle.popover
        
        //Setup popover presentation controller
        dropDownView.popoverPresentationController?.delegate = self
        dropDownView.popoverPresentationController?.sourceView = sender
        dropDownView.popoverPresentationController?.sourceRect = sender.bounds
        
        //Present the popover menu
        self.present(dropDownView, animated: false, completion: nil)
    }

    //UIPopoverPresentationController Delegate method. Forces popover instead of modal presentation for iphone
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
