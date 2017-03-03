//
//  ContactViewController.swift
//  CRRD
//
//  Created by Fahmy Mohammed on 1/30/17.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    //Holds CSC mail, online, facebook ,and twitter details used in the table view cells.
    private struct ContactDetails {
        var identifier = ""
        var link = ""
        var image: UIImage! = nil
    }
    
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var aboutContact: UILabel!
    private var contactDetails: [ContactDetails] = []
    
    //Gets the strings stored in the Strings.plist file
    private var strings: [String: Any] = Utils.getStrings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewTheme()
        populateContactDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - Theme
    
    //Adjusts look of items in view
    func viewTheme(){
        
        //Hide back button label from the navigation bar
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        //Set view label text
        self.title = strings["ContactActivityLabel"] as! String?
        contactLabel.text = strings["ContactCSCLabel"] as! String?
        aboutContact.text = strings["AboutContact"] as! String?
    }
    
    
    //MARK: - Navigation and Data Handling
    
    //Add CSC mail, online facebook and twitter info
    func populateContactDetails() {
        
        //Add CSC email details
        contactDetails.append(ContactDetails(identifier: "mail", link: ((strings["CSCEmail"]) as! String?)!, image: #imageLiteral(resourceName: "email_black")))
        
        //Add CSC online details
        contactDetails.append(ContactDetails(identifier: "link", link: ((strings["CSCOnline"]) as! String?)!, image: #imageLiteral(resourceName: "public_black")))
        
        //Add CSC facebook details
        contactDetails.append(ContactDetails(identifier: "link", link: ((strings["CSCFacebook"]) as! String?)!, image: #imageLiteral(resourceName: "facebook_black")))
        
        //Add CSC twitter details
        contactDetails.append(ContactDetails(identifier: "link", link: ((strings["CSCTwitter"]) as! String?)!, image: #imageLiteral(resourceName: "twitter_black")))
    }
    
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
    
    //Displays an alert on the screen and prompts the user with a choice to navigate to the link
    func openLink(_ link: String) {
        
        //Setup alert menu
        let alertMenu = UIAlertController(title: nil, message: "Open link", preferredStyle: .actionSheet)
        let cancelAlertMenu = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //Setup action that allows the user to open the link when pressed
        let actionHandler = { (action:UIAlertAction) -> Void in
            UIApplication.shared.open(NSURL(string: link)! as URL)
        }
        let linkAction = UIAlertAction(title: "\(link)", style: .default, handler: actionHandler)
        
        //Add call and cancel actions to the alert menu
        alertMenu.addAction(linkAction)
        alertMenu.addAction(cancelAlertMenu)
        
        present(alertMenu, animated: true, completion:  nil)
    }

    //Action performed when CSC email link is pressed
    func openEmail(_ subject: String, _ email: String) {
        
        //Reference to mail compose view controller
        let mailCompose = MFMailComposeViewController()
        
        //Setup mail compose view controller
        mailCompose.mailComposeDelegate = self
        mailCompose.setSubject(subject)
        mailCompose.setToRecipients([email])
        //mailCompose.navigationBar.barTintColor = Utils.Colors.cscGreenDark
        mailCompose.navigationBar.tintColor = UIColor.white


        
        //Present mail compose view controller
        present(mailCompose, animated: true, completion: nil)
    }
    
    //Allows access to MFMailComposeViewController result and dismisses view
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil) //Dismiss mail compose view
    }

    
    // MARK: - Table view data source
    
    //Number of rows in table view section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactDetails.count
    }
    
    //Display contact details in table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Cell uses ContactDetailCell as template
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell", for: indexPath) as! DetailTableViewCell
        
        //Wrap characters if URL is too long for one line
        cell.contactCellLabelValue.lineBreakMode = NSLineBreakMode.byCharWrapping
        
        //Configure table view cell
        cell.contactCellLabelValue.text = contactDetails[indexPath.row].link
        cell.contactCellImage.image = contactDetails[indexPath.row].image
        
        //Change image tint and label text color
        cell.contactCellLabelValue.textColor = Utils.Colors.cscBlue
        cell.contactCellImage.tintColor = Utils.Colors.cscBlue
        
        return cell
    }
    
    //Perform action for selected contact detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Action for opening link, mail or address
        switch contactDetails[indexPath.row].identifier {
        case "mail":
            openEmail((strings["CSCInfoEmailSubject"] as! String), contactDetails[indexPath.row].link)
        case "link":
            openLink(contactDetails[indexPath.row].link)
        default:
            break
        }
    }
    
}



