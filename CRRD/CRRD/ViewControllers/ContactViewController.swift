//
//  ContactViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 Fahmy Mohammed - Team Reticulum. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, UIPopoverPresentationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var onlineURLButton: UIButton!
    @IBOutlet weak var facebookURLButton: UIButton!
    @IBOutlet weak var twitterURLButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide back button from the navigation bar
        self.navigationItem.setHidesBackButton(true, animated: false)
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
    
    //Action performed when CSC email link is pressed
    @IBAction func email(_ sender: Any) {
        //Reference to mail compose view controller
        let mailCompose = MFMailComposeViewController()
        
        //Setup mail compose view controller
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject("ReUse information request")
        mailCompose.setToRecipients(["info@sustainablecorvallis.org"])
        
        //Present mail compose view controller
        present(mailCompose, animated: true, completion: nil)
    }
    
    //MFMailComposeViewController result method. 
    //Allows access to MFMailComposeViewController result and dismisses view
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil) //Dismiss mail compose view
    }

    //Action performed when CSC URL is pressed
    @IBAction func onlineURL(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "http://sustainablecorvallis.org/")! as URL)
    }

    //Action performed when CSC facebook URL is pressed
    @IBAction func facebookURL(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://www.facebook.com/SustainableCorvallis/")! as URL)
    }
    
    //Action performed when CSC twitter URL is pressed
    @IBAction func twitterURL(_ sender: Any) {
        UIApplication.shared.open(NSURL(string: "https://twitter.com/sustaincorv")! as URL)
    }
}
