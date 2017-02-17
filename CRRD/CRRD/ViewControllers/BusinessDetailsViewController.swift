//
//  BusinessDetailsViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 2/02/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class BusinessDetailsViewController: UIViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessURLButton: UIButton!
    @IBOutlet weak var businessAddressButton: UIButton!
    @IBOutlet weak var businessPhoneButton: UIButton!
    var business: BusinessMO! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        businessNameLabel.text = business.name
        //businessURLButton.titleLabel?.text = business.website
        //businessAddressButton.titleLabel?.text = business.address_line_1
        //businessPhoneButton.titleLabel?.text = business.phone
        
        //Hide back button from the navigation bar
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        //Set navigation bar label to business name
        self.navigationItem.leftBarButtonItem?.title = business.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Navigation
    
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

    
    @IBAction func businessURL(_ sender: Any) {
        //UIApplication.shared.open(NSURL(string: "http://www.arcbenton.org/")! as URL)
    }

    @IBAction func businessAddress(_ sender: Any) {
        /*
        let baseUrl: String = "http://maps.apple.com/?q="
        let encodedName = "928 NW Beca Ave Corvallis OR 97330"
        let finalUrl = baseUrl + encodedName
        UIApplication.shared.open(NSURL(string: finalUrl)! as URL)
        */
        
    }
    
    @IBAction func businessPhone(_ sender: Any) {
        //(541)754 9011
    }
}
